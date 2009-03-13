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
    import flash.utils.ByteArray;
    import flash.display.BitmapData;

    import flexunit.framework.TestCase;

    public class URLFileVariableTest extends TestCase
    {
        public function URLFileVariableTest(methodName:String = null)
        {
            super(methodName);
        }

        /**
         * Ensure a URLFileVariable is in the correct state after instantiation
         */
        public function testCreate():void
        {
            const FILE_NAME:String = "image.jpg";
            var bitmapData:BitmapData = new BitmapData(100, 100, false, 0x000);
            var fileData:ByteArray = bitmapData.getPixels(bitmapData.rect);
            var fileVariable:URLFileVariable = new URLFileVariable(fileData, FILE_NAME);

            assertEquals("File name should match that supplied to constuctor", fileVariable.name, FILE_NAME);
            assertEquals("File data should match that supplied to constuctor", fileVariable.data, fileData);
        }
    }
}