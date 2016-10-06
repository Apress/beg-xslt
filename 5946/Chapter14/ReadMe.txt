Depending upon which versions of MSXML you have on your system,
TVGuide3.html may not open. In this case, try TVGuide3a.html.

The change is as follows:

The first line in the try block of function displayTransformedXML():

TVGuide3.html:

          // Create Template object
          xslTemplate = new ActiveXObject('MSXML2.XSLTemplate');


TVGuide3a.html:

          // Create Template object
          xslTemplate = new ActiveXObject('MSXML2.XSLTemplate.4.0');
