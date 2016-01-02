##  Another step in the use of ESAPI and AppSensor Jars from .Net/C# (using Jni4Net)

Yesterday at the [OWASP EU Tour London Chapte](https://www.owasp.org/index.php/EUTour2013_London_Agenda)r event meeting I presented the next step of my research on using ESAPI and AppSensor inside a .NET application like TeamMentor (using Jni4Net to allow the JVM to work side by side with the CLR).

The source code of the demo I presented is posted to the [github.com:DinisCruz/TeamMentor_3_3_AppSensor](http://github.com:DinisCruz/TeamMentor_3_3_AppSensor) repo, and this post shows a number of screenshots of what is in there.

I used **TeamMentor's TBot C# **and **AngularJS** pages to create the prototypes (since it is very easy and fast to code in that enviroment)

The pages were added to the main **_TBot _**control panel, in 3 new sections: **AppSensor**, **AppSensor/ESAPI** and **AppSensor/JVM**:

![image](images/another-step-in-the-use-of-esapi-and-appsensor-jars/image_1.png)

Let's look at all of them and see what they do.

**JavaProperties**

Shows the Properties of the current JVM, and is a good first script to run (since it shows that the Jni4Net CLR to JVM bridge is correctly set up)

[![image](images/image_thumb_25255B1_25255D1.png)](http://lh4.ggpht.com/-pUaZd6PJLfM/Ua2tnHUCjxI/AAAAAAAAMZM/0EOxCVn_SUY/s1600-h/image%25255B5%25255D.png)

**Jars_In_Class_Path**

This one shows the Jar's currently loaded and some details about the loaded classes

[![image](images/image_thumb_25255B2_25255D1.png)](http://lh6.ggpht.com/-AE4-DZt-cRM/Ua2towf9CiI/AAAAAAAAMZc/PGmphVc7p9c/s1600-h/image%25255B8%25255D.png)

The image above shows that there is only one jar loaded at start (**jni4net.j-0.8.6.0.jar**) and below is what it looks after the _**Setup AppSensor**  _Tbot page is executed

[![image](images/image_thumb_25255B3_25255D1.png)](http://lh4.ggpht.com/-6Kb3PyKfdOs/Ua2tqr8c6QI/AAAAAAAAMZs/SNg65Qa7QVE/s1600-h/image%25255B11%25255D.png)

**Setup AppSensor**

This will load up the AppSensor Jars and perform a simple test to see if one of the expected classes can be loaded

[![image](images/image_thumb_25255B4_25255D1.png)](http://lh6.ggpht.com/-z_N-icMNS6s/Ua2tsajPUWI/AAAAAAAAMZ8/5Fr3ILWWvZk/s1600-h/image%25255B14%25255D.png)

**View_ESAPI_Encodings**

Once we have the ESAPI loaded we can open up this page that shows **what all the ESAPI encodings looks like**

[![image](images/image_thumb_25255B5_25255D1.png)](http://lh3.ggpht.com/-gKbEuJVJ_7E/Ua2tuJDZ0pI/AAAAAAAAMaM/NBkqr4BOScU/s1600-h/image%25255B17%25255D.png)
[![image](images/image_thumb_25255B7_25255D1.png)](http://lh4.ggpht.com/-UHNifhDWLm8/Ua2tvjT4lYI/AAAAAAAAMac/iiDIV2fSedc/s1600-h/image%25255B21%25255D.png)

Note how many they are: **encodeForHTML , encodeForHTMLAttribute, encodeForCSS, encodeForJavascript, encodeForVBScript, encodeForLDAP, encodeForDN, encodeForXPath, encodeForXML, encodeForXmlAttribute, encodeForURL**
**
**You can use this GUI to try out what a specific encoding looks like.

For example change the text on the left and click on of the **_'encodeFor...'_** buttons

[![image](images/image_thumb_25255B9_25255D.png)](http://lh4.ggpht.com/-4SVsh8Q4To0/Ua2txY99QbI/AAAAAAAAMas/gLeWm9Nm0lc/s1600-h/image%25255B27%25255D.png)

**AppSensor_Logs**

Shows the currently registered logs

[![image](images/image_thumb_25255B10_25255D.png)](http://lh4.ggpht.com/-ah5uDjgatMU/Ua2tzEOejdI/AAAAAAAAMa8/Q35ILwsVlT0/s1600-h/image%25255B30%25255D.png)

To help to create a new log entry, this page provides a link to:

**Create_AppSensor_Exception**

which looks like this:

[![image](images/image_thumb_25255B11_25255D.png)](http://lh4.ggpht.com/-RQ8RpHoCj4A/Ua2t0SqJs0I/AAAAAAAAMbM/FJe99tsE7V0/s1600-h/image%25255B33%25255D.png)

This page (for testing) allows the use of the **ex **querystring parameter to create a new AppSensor log message

[![image](images/image_thumb_25255B12_25255D.png)](http://lh4.ggpht.com/-QaDlWET1-4Q/Ua2t1w-DLdI/AAAAAAAAMbc/nA7KjAdqAeA/s1600-h/image%25255B36%25255D.png)

and clicking on **View AppSensor Logs**, which show details of the log:

[![image](images/image_thumb_25255B13_25255D.png)](http://lh6.ggpht.com/-mv3P_aRoQYo/Ua2t3d7zKTI/AAAAAAAAMbs/g1wSJvQPoKY/s1600-h/image%25255B39%25255D.png)