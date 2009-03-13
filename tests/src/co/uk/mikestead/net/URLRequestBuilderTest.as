/*
  Copyright (c) Mike Stead 2009, All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

  * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.

  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.

  * Neither the name of Adobe Systems Incorporated nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package co.uk.mikestead.net
{
    import flash.errors.EOFError;
    import flash.net.URLRequestHeader;
    import flash.utils.ByteArray;
    import flash.display.BitmapData;
    import flash.net.URLRequestMethod;
    import flash.net.URLRequest;
    import flash.net.URLVariables;

    import flexunit.framework.TestCase;

    public class URLRequestBuilderTest extends TestCase
    {
        private const THUMB_ID:String = "thumbnail";
        private const THUMB_FILE_NAME:String = "thumb.pdf";
        private const USERNAME_ID:String = "username";
        private const USERNAME:String = "mike";

        private var thumbFileLength:int;

        public function URLRequestBuilderTest(methodName:String = null)
        {
            super(methodName);
        }

        /**
         * Validate headers for a multipart/form-data encoded URLRequest
         */
        public function testBuildHeaders():void
        {
            var request:URLRequest = createMultipartRequest();
            var headers:Array = request.requestHeaders;

            assertEquals("The request method type should be POST", request.method, URLRequestMethod.POST);
            assertTrue("The request content type should be multipart/form-data",
                       request.contentType.search("multipart/form-data") == 0);
            assertTrue("The request content type should contain a boundray mark",
                       request.contentType.search("boundary=") > -1);
            assertNull("There should be no request url set", request.url);

            // test for accept header
            var resultSet:Array = headers.filter(function(h:URLRequestHeader, i:int, arr:Array):Boolean
            {
                return (h.name == "Accept" && h.value == "*/*");
            });

            assertEquals("The request Accept header should be set to '*/*'", resultSet.length, 1);

            // test for cache control header
            resultSet = headers.filter(function(h:URLRequestHeader, i:int, arr:Array):Boolean
            {
                return (h.name == "Cache-Control" && h.value == "no-cache");
            });

            assertEquals("The request Cache-Control header should be set to 'no-cache'", resultSet.length, 1);
        }

        /**
         * Validate body of a URLRequest with plain (string name-value pairs) body.
         */
        public function testBuildPlainBody():void
        {
            var variables:URLVariables = new URLVariables();
            variables[USERNAME_ID] = USERNAME;
            var request:URLRequest = new URLRequestBuilder(variables).build();

            assertStrictlyEquals("The variables in the request.data property should be the " +
                                 "same as those passed to the URLRequestBuilder",
                                 request.data,
                                 variables);
        }

        /**
         * Validate body of URLRequest with multipart/form-data encoding.
         */
        public function testBuildMultipartBody():void
        {
            const BOUNDARY_DECL:String = "boundary=";
            const MARK:String = "--";
            const LF:String = "\r\n";

            var request:URLRequest = createMultipartRequest();
            var body:ByteArray = ByteArray(request.data);
            body.position = 0;

            // determine the boundry from the header
            var ct:String = request.contentType;
            var boundary:String = ct.substr(ct.indexOf(BOUNDARY_DECL) + BOUNDARY_DECL.length);

            body = ByteArray(request.data);
            body.position = 0;

            // we'll examine the two fields created in createMultipartRequest, one file one string
            var fieldsExamined:uint = 0;
            var field:String;

            try
            {
                // the order of the fields is not guaranteed
                while (fieldsExamined < 2)
                {
                    field = body.readUTFBytes((MARK + boundary + LF).length);
                    assertEquals("The first line of the request body should be a boundry decl",
                                 (MARK + boundary + LF),
                                 field);

                    // read the next line so we can determine the name + type of the field we're parsing
                    var pos:Number = body.position;
                    var s:Number = (THUMB_ID.length > USERNAME_ID.length) ? THUMB_ID.length : USERNAME_ID.length;
                    var disposition:String = body.readUTFBytes(("Content-Disposition: form-data; name=\"").length + s);

                    // return cursor to the previous position
                    body.position = pos;

                    // file field
                    if (disposition.indexOf(THUMB_ID) != -1)
                    {
                        field = body.readUTFBytes(("Content-Disposition: form-data; name=\"" + THUMB_ID +
                                                   "\"; filename=\"" + THUMB_FILE_NAME + "\"" + LF).length);

                        assertEquals("The second line of the file field should describe the content disposition",
                                     "Content-Disposition: form-data; name=\"" + THUMB_ID +  "\"; filename=\"" + THUMB_FILE_NAME + "\"" + LF,
                                     field);

                        field = body.readUTFBytes(("Content-Type: application/octet-stream" + LF).length);
                        assertEquals("The third line of the file field should describe the content type",
                                     "Content-Type: application/octet-stream" + LF,
                                     field);

                        field = body.readUTFBytes(LF.length);

                        assertEquals("The fourth line of the file field should be empty",
                                     LF,
                                     field);

                        assertTrue("The file content should sit at the end of the file field decleration",
                                   (body.position + thumbFileLength) < body.length);

                        // move the byte array cursor over the thumbnail data. If we run over the
                        // end of the file this will be picked up through an EOF exception
                        body.position += thumbFileLength;

                        fieldsExamined++;
                    }
                    // string field
                    else if (disposition.indexOf(USERNAME_ID) != -1)
                    {
                        field = body.readUTFBytes(("Content-Disposition: form-data; name=\"" + USERNAME_ID +  "\"" + LF).length);
                        assertEquals("The second line of the string field should be the content disposition >" + field,
                                     "Content-Disposition: form-data; name=\"" + USERNAME_ID +  "\"" + LF,
                                     field);

                        field = body.readUTFBytes(LF.length);
                        assertEquals("The third line of the request body should be empty [string]",
                                     LF,
                                     field);

                        field = body.readUTFBytes(USERNAME.length);
                        assertEquals("The fourth line of the request body should be the field value [string] '"+ USERNAME +"'",
                                     USERNAME,
                                     field);

                        fieldsExamined++;
                    }
                    else if (fieldsExamined < 2)
                    {
                        assertFalse("The second line of the request body should contain a valid field name");
                        break;
                    }

                    field = body.readUTFBytes(LF.length);
                    assertEquals("Each field should end with a line feed",
                                 LF,
                                 field);                    
                }

                field = body.readUTFBytes((MARK + boundary + MARK + LF).length);
                assertEquals("The end of the body should be marked with a final boundary",
                            (MARK + boundary + MARK + LF),
                            field);
                assertEquals("There should be no more content in the body after the final boundry mark",
                             body.position,
                             body.length);
            }
            catch(e:EOFError)
            {
                assertFalse("There should be more data within the request body");
            }
        }

        /**
         * Create (what should be) a valid multipart URLRequest
         *
         * @return A valid URLRequest instance with multipart/form-data encoding
         */
        private function createMultipartRequest():URLRequest
        {
            var bitmapData:BitmapData = new BitmapData(100, 100, false, 0x000);
            var fileData:ByteArray = bitmapData.getPixels(bitmapData.rect);
            thumbFileLength = fileData.length;

            var variables:URLVariables = new URLVariables();
            variables[USERNAME_ID] = USERNAME;
            variables[THUMB_ID] = new URLFileVariable(fileData, THUMB_FILE_NAME);

            var request:URLRequest = new URLRequestBuilder(variables).build();
            return request;
        }
    }
}