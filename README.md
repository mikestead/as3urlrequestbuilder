# AS3 URLRequestBuilder

The follow blog post which originally accompanied this work has been copied here for longevity.

## FileReference Revisited

> 2009-01-04

In a recent post I outlined some of the concerns I have with the [FileReference](http://livedocs.adobe.com/flex/3/langref/flash/net/FileReference.html) class, namely:

- It's responsible for providing file selection, file access, and file upload/download, which violates the [Single Responsibility Principal](http://en.wikipedia.org/wiki/Single_responsibility_principle).
- It restricts the user to one file upload at a time, even though [multipart/form-data](http://www.faqs.org/rfcs/rfc2388.html) is used as the encoding, an encoding with no such restriction.
- [URLLoader](http://livedocs.adobe.com/flex/3/langref/flash/net/URLLoader.html) and [URLStream](http://help.adobe.com/en_US/AS3LCR/Flash_10.0/flash/net/URLStream.html) are the preferred way to dispatch an HTTP request and retrieve a response. `FileReference` adds unnecessary duplication and restrictions when compared with these classes.
- You can bundle other data with a `FileReference.upload` request by setting the data property of the `URLReqest` object passed to it, but the context is confusing (i.e you're explicitly uploading a file through FileReference so bundling other data is somewhat unintuitive).

[Neer](http://www.neerfri.com/2007/12/flex-multipartform-data-post-request.html) put together a nice set of classes to deal with these issues, mimicking the general structure of AS3's URL `Request/Loader/Variables`. Using these you can collate text and files (binary data) to be transferred to the server within a `MultipartVariables` instance, pass this to a `MultipartRequest` and then POST this to the server using `MultipartLoader`, which will finish by returning any response.

This all seems fairly reasonable, and familiar if you've used the AS3 classes to send and load data before. There was one primary question this raised however. _Why do we need to mimic as opposed to reuse these core classes?_

With a little spare time over the holidays I thought I'd try to find an answer. I decided to approach this by walking through the problem, starting with my preferred implementation (given the core classes available), then withdrawing to the feasible.

### Preparing Data For the Server

[URLVariables](http://help.adobe.com/en_US/AS3LCR/Flash_10.0/flash/net/URLVariables.html) is a class which allows for the dynamic setting of properties. Each one of these properties turns into a name-value string pair, to be sent to the server, when associate with a [URLRequest](http://help.adobe.com/en_US/AS3LCR/Flash_10.0/flash/net/URLRequest.html). To bind variables to a request, `URLRequest` makes public a `data` property which alongside `URLVariables`, accepts a `String` or `ByteArray` instance.

Here's an example of creating some variables to send to the server and adding them to a `URLRequest`.

```as3
var variables:URLVariables = new URLVariables();
variables.propertyOne = ""valueOne"";
variables.propertyTwo = ""valueTwo"";

var request:URLRequest = new URLRequest();
request.data = variables;
```

While each of the variables we send needs an identifying name, for our purposes it's value may be string or binary, and if binary will need a file name to save to on the server.

We could extend `URLVariables` or create an entirely separate variables class, but the simplest solution is to factor out these new attributes into a class of their own. We'll call this `URLFileVariable`.

```as3
class URLFileVariable
{
	/**
	 * Constructor
	 *
	 * @param data File data
	 * @param name Name to save file under on server, e.g ""someImage.jpg""
	 */
	public function URLFileVariable(data:BinaryData, name:String)
	
	/**
	 * File data
	 */
	public function get data():ByteArray
	
	/**
	 * Name to save file under on server, e.g ""someImage.jpg""
	 */
	public function get name():String
}
```

With an instance of this we can set a `URLVariables` property.

```as3
var variables:URLVariables = new URLVariables();
variables.userName = ""mike"";
variables.userThumbnail = new URLFileVariable(jpegData, ""mike.jpg"");
```

You may have noticed this requires the file data to be in memory. We can accomplish this using the [FileReference.load](http://help.adobe.com/en_US/AS3LCR/Flash_10.0/flash/net/FileReference.html#load()) method which was introduced under Flash Player 10. This method loads the byte data of a local file into the Flash player and makes it available through the `data` property of its associated `FileReference` instance.

(My renaming of the `FileReference` instance in the following example is meant to help highlight the multiple responsibilities bundled with this class.)

```as3
// browse and select a local file
var filePicker:FileReference = new FileReference();
filePicker.addEventListener(Event.SELECT, onFileChosen);
filePicker.browse(); // this needs to be triggered through an interaction event

// Event handler called when user has picked a file
public function onFilePicked(event:Event):void
{
    // load the file into the Player
    var fileLoader:FileReference = filePicker;
    fileLoader.addEventListener(Event.COMPLETE, onFileLoadComplete);
    fileLoader.load();
}

// Event handler called when file has loaded into memory
public function onFileLoadComplete(event:Event):void
{
    var variables:URLVariables = new URLVariables();

    // Now we can create our URLFileVariable instance passing the loaded data
    var file:FileReference = fileLoader;
    variables.userThumbnail = new URLFileVariable(file.data, file.name);
}
```

Now this is by no means ideal. Having to preload potentially many files before submission raises the real possibility of out of memory exceptions. This is unfortunately one issue which cannot be addressed without lower level (i.e. Player) modifications, so this will have to do.

### Constructing an Encoded HTTP Request

[URLRequest](http://help.adobe.com/en_US/AS3LCR/Flash_10.0/flash/net/URLRequest.html) is responsible for encapsulating GET and POST [HTTP requests](http://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods). With it you can customize the headers and body of any such HTTP request to be sent to the server.  This fits perfectly with our need to POST strings and files using `multipart/form-data` encoding so we should be able to use it out of the box.

Our next dilemma is when to apply the encoding to a `URLRequest` and the variables it contains. Given that any `URLVariables` instance containing a property of type `URLFileVariable` would need sent using `multipart/form-data` encoding the [URLRequest.data](http://help.adobe.com/en_US/AS3LCR/Flash_10.0/flash/net/URLRequest.html#data) setter seems like the ideal location to deduce and apply this encoding. Indeed looking at the documentation for this setter you can see encodings are already deduced in this way for the other types it supports.

Time to extend `URLRequest` and override this setter... ah, _URLRequest is a final class so cannot be extended_. Back to the drawing board.

I've searched and pondered as to why this class would be final, but without documentation or viewing the underlying code I can't be sure. I expect that keeping areas of this class immutable would be the answer. Nevertheless this is a significant class to lock down and would have hoped for an alternative design decision.

Without the ability to extend `URLRequest` we'll need to introduce a class to build our request given a `URLVariables` instance. We'll call this `URLRequestBuilder`.

```as3
class URLRequestBuilder
{
	/**
	 * Constructor
	 *
	 * @param variables Properties to be encoded within a URLRequest
	 */
	public function URLRequestBuilder(variables:URLVariables)
	
	/**
	 * Construct a URLRequest instance with the correct encoding
	 * given the variables provided.
	 *
	 * @return URLRequest instance primed and ready for submission
	 */
	public function build():URLRequest
}
```

Which could then be used like so:

```as3
var variables:URLVariables = new URLVariables();
variables.userName = ""mike"";
variables.userThumbnail = new URLFileVariable(jpegData, ""mike.jpg"");

var request:URLRequest = new URLRequestBuilder(variables).build();
```

Obviously this class won't need to do much if the variables passed in don't contain a URLFileVariable.

### Dispatching a URLRequest and Monitoring Progress

In order to send a URLRequest off to the server we need to ask a class, which is capable of returning a response, to dispatch the URLRequest. To do this we have a few choices, we can use [Loader](http://help.adobe.com/en_US/AS3LCR/Flash_10.0/flash/display/Loader.html), [URLLoader](http://help.adobe.com/en_US/AS3LCR/Flash_10.0/flash/net/URLLoader.html) or [URLStream](http://help.adobe.com/en_US/AS3LCR/Flash_10.0/flash/net/URLStream.html). You can view the documentation for each to get better understanding of their roles, but assuming we'll just want a simple text response `URLLoader` will do nicely.

Before we dispatch a request we'll want to register to listen for upload progress events. The loader classes above all provide exception and progress events for connecting and downloading data from a server, but provide no means to monitor uploads. `URLRequest` would be another possible place to look for upload event dispatching but as it's (quite rightly) not responsible for the transmission of itself there is no such support.

You may think the next logical step would be to create our own `Loader` implementation using a [Socket](http://help.adobe.com/en_US/AS3LCR/Flash_10.0/flash/net/Socket.html). But `Socket` too has [no support](http://tech.groups.yahoo.com/group/flexcoders/message/72182) for monitoring the progress of an upload so offers no advantages. _I can find no foolproof means in Flash to monitor upload progress other than through FileReference_.

This lack of event dispatching for uploads is quite surprising given the potential for large amounts of data to be sent to the server via a `URLRequest`, not to mention via a `Socket`.

So at this point we hit a significant dead end. We've come as far as to cover the functionality in Neer's version, and we've done this through the introduction of just two lightweight classes, providing greater flexibility in the process; but we can go no further.

Here's the final example covering how to send a request off, and receive a response from the server (for a more comprehensive example, including user interface and server-side script, download the source code).

```as3
// Create variables to send off to server
var variables:URLVariables = new URLVariables();
variables.userName = ""mike"";
variables.userThumbnail = new URLFileVariable(jpegData, ""mike.jpg"");

// Build the multipart encoded request and set the url of where to send it
var request:URLRequest = new URLRequestBuilder(variables).build();
request.url = ""some.web.service.php"";

// Create the loader and transmit the request
var loader:URLLoader = new URLLoader();
loader.addEventListener(Event.COMPLETE, onServerResponse);
loader.load(request);

// Handle the response
public function onServerResponse(event:Event):void
{
    var loader:URLLoader = URLLoader(event.target);
    trace(""onServerResponse: "" + loader.data);
}
```
