##  Using Jni4Net (Part 3) - Writing and Invoking O2 Methods from Java and Eclipse.pdf 

After [Using Jni4Net (Part 1) - To C# REPL a java process (ZAP Proxy)](http://diniscruz.blogspot.co.uk/2012/11/using-jni4net-part-1-to-c-repl-java.html) and  [Using Jni4Net (Part 2) - Controling OWASP ZAP remotely (via Java BeanShell REPL in .Net)](http://diniscruz.blogspot.co.uk/2012/11/using-jni4net-part-2-controling-owasp.html) the next step was to see if we could consume (and code) the .NET APIs from Java.

And again [Jni4Net](http://jni4net.sourceforge.net/) really worked!

Here is a .NET WinForms control, coded and executed from the (Eclipse written) Java code:

[![](images/CropperCapture_5B77_5D.jpg)](http://1.bp.blogspot.com/-Cz_lRShoNP0/UKdC_AYD10I/AAAAAAAACR4/NScD5B10dx0/s1600/CropperCapture%5B77%5D.jpg)

Once we could create *.jar files, it was a small step to create an Eclipse plugin that would load up a CLR and popup a C# based Form.  

[![](images/CropperCapture_5B78_5D.jpg)](http://4.bp.blogspot.com/-dUw6WGyOkO8/UKdDAMjxmlI/AAAAAAAACSQ/gpX-1H-zRak/s1600/CropperCapture%5B78%5D.jpg)

Or more interestingly an C# REPL editor (running in the same process as Eclipse):

[![](images/CropperCapture_5B79_5D.jpg)](http://2.bp.blogspot.com/-fI-RLXfdv2E/UKdFAIa0JkI/AAAAAAAACTI/ItI1fcOoCmI/s1600/CropperCapture%5B79%5D.jpg)
  
For more details on how these PoCs were created, take a [look at this pdf](https://dl.dropbox.com/u/81532342/O2%20Raw%20Docs/Pdfs/Using%20Jni4Net%20%28Part%203%29%20-%20Writing%20and%20Invoking%20O2%20Methods%20from%20Java%20and%20Eclipse.pdf):