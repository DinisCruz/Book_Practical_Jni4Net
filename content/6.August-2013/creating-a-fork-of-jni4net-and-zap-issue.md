##  Creating a Fork of Jni4Net,dealing with 'Attempted to read or write protected memory' problem and what I had to do to make it work with ZAP 

An O2 user was having some issues with the Jni4Net scripts and I think the root cause is because the current O2 Scripts uses the **_jni4net.n-0.8.6.0.dll _**which is the version currently available for download

![image](images/image_thumb[14].png)

TLDR: The code of the [patched version is here](https://github.com/o2platform/Fork_Jni4Net) the compiled [binaries are here](https://dl.dropboxusercontent.com/u/81532342/O2%20Files/jni4net-0.8.7.0-bin_Patched.zip)

**NOTE: THIS VERSION IS CURRENTLY published as DRAFT** since I'm on the Algarve (i.e. the beach is waiting) and don't have time to proof read the text below (which is posted how I wrote it at the time)

The problem is that with the 0.8.6 version we would get an **_'Attempted to read or write protected memory'_** error when trying to connect to an existing Java process we injected O2 into (see note below for more details)

If I remember correctly (when I was able to make it work before, see [Using Jni4Net part 1](http://blog.diniscruz.com/2012/11/using-jni4net-part-1-to-c-repl-java.html), [part 2](http://blog.diniscruz.com/2012/11/using-jni4net-part-2-controling-owasp.html),  [part 3](http://blog.diniscruz.com/2012/11/using-jni4net-part-3-writing-and.html) and [part 4](http://blog.diniscruz.com/2012/11/jni4net-part-4-integrating-appscan-with.html)) the solution is to use the latest version of Jni4Net, which is not available for direct download, but its code it at: _**http://jni4net.googlecode.com/svn jni4Net**_

Using the _**git svn clone -s http://jni4net.googlecode.com/svn jni4Net **_command, I created a local clone of the SVN repo:

![image](images/image_thumb_25255B8_25255D1.png)

After getting the compilation and generation process right (see below), I had this folder:

![image](images/image_thumb_25255B48_25255D.png)

I then used these scripts (see [this gist for code](https://gist.github.com/DinisCruz/6281106)) to:

**1) start ZAP and inject O2 into the new process:**

![image](images/image_thumb_25255B54_25255D.png)

**2) hook VisualStudio to that process** (assumes there is only one java.exe process)  

![image](images/image_thumb_25255B59_25255D.png)

**3) create bridge and output java properties** (inside the ZAP REPL)

![image](images/image_thumb_25255B55_25255D.png)

4) Executed **_PoC - Jni4Net - Classes, Methods, Fields in target.h2_** script (inside ZAP process)

![image](images/image_thumb_25255B56_25255D.png)

which listed all loaded java classes (and its decompiled code):

![image](images/image_thumb_25255B57_25255D.png)

To make this work (and deal with the **_'Attempted to read or write protected memory'_** prob) I had to copy the **_jni4net.j-0.8.7.0.jar_** to the ZAP default class path and manually skip a bit of code when connected to VisualStudio

![image](images/image_thumb_25255B58_25255D.png)

**NOTE XYZ)**  **How I got the whole compilation process to work**

I started by opening the **_jni4net.sln_** file in VS 2010.

But on first compile I had this error:

![image](images/image_thumb_25255B9_25255D1.png)

which was created by the missing **_selvin.exportdllattribute-0.2.6.0.dll_**

![image](images/image_thumb_25255B10_25255D1.png)

which looks like should be here:

![image](images/image_thumb_25255B11_25255D1.png)

let's take a look at the**_ v0-8-generics_** branch

![image](images/image_thumb_25255B14_25255D.png)

but it is also not there, so I just downloaded it from:

We can find the file on the tools

![image](images/image_thumb_25255B12_25255D1.png)

... and saved it to:

![image](images/image_thumb_25255B15_25255D1.png)

... updated the references

![image](images/image_thumb_25255B16_25255D1.png)

Now the code compiles, but we get this error:

![image](images/image_thumb_25255B17_25255D.png)

which is caused by this post build command:

![image](images/image_thumb_25255B18_25255D.png)

and is resolved by downloading this file:

![image](images/image_thumb_25255B19_25255D.png)

into this folder:

![image](images/image_thumb_25255B20_25255D.png)

I was able to get it to compile by changing the **_selvin.exportdll-0.2.6.0.exe_** to _**selvin.exportdll-0.2.5.0.exe **_(couldn't find the 0.2.6.0 version)

![image](images/image_thumb_25255B21_25255D.png)

Next there was a bunch of NUnit errors, which were resolved using

![image](images/image_thumb_25255B22_25255D.png)

and now we have a clean compilation (with only a bunch of warnings)

![image](images/image_thumb_25255B25_25255D1.png)

But, they all fail to execute:

![image](images/image_thumb_25255B26_25255D.png)

Which was a good sign that I should look for a readme.txt, which I found in the repo root:

![image](images/image_thumb_25255B27_25255D.png)

Running loadTools.cmd:

![image](images/image_thumb_25255B28_25255D.png)

... downloads the missing files into the lib folder:

![image](images/image_thumb_25255B29_25255D.png)

Since we now have the 0.2.6.0 versions I updated back the VS solution (and removed the nUnit package from Nuget)

Then I executed

![image](images/image_thumb_25255B30_25255D.png)

and

![image](images/image_thumb_25255B31_25255D.png)

this took a while, and although most looked ok:

![image](images/image_thumb_25255B33_25255D.png)

it looks like the last one failed:

![image](images/image_thumb_25255B32_25255D.png)

But the required files seemed to have been created:

![image](images/image_thumb_25255B35_25255D.png)

And the Unit tests now pass:

![image](images/image_thumb_25255B34_25255D.png)

I still don't like the fact that we have that build error, so I track it to the missing NUnit installation. So I downloaded and installed the expected one

![image](images/image_thumb_25255B37_25255D.png)

but since I'm on a x64 VM and the path is hard-coded in the Maven script, I had to copy the installed nunit files to the expected folder:

![image](images/image_thumb_25255B40_25255D1.png)

humm, maybe that wasn't such a good idea:

![image](images/image_thumb_25255B41_25255D.png)

I think the problem could be caused by the fact that I'm currently using an x64 JDK:

![image](images/image_thumb_25255B42_25255D1.png)

So let's try with a x86 (32bit) version of the JDK

![image](images/image_thumb_25255B43_25255D.png)

now the tests expect to find Nunit in the (x86) folder:

![image](images/image_thumb_25255B44_25255D.png)

which should be fixed by renaming the **_NUnit-2.5.8_** folder to the expected value:

![image](images/image_thumb_25255B45_25255D.png)

And finally we have a successful complete build:

![image](images/image_thumb_25255B46_25255D.png)

with all created files placed inside the target folder:

![image](images/image_thumb_25255B47_25255D.png)

  
**NOTE XYZ)** replicating the original **_'Attempted to read or write protected memory'_** error

get this error when trying to connect to a java process like ZAP:

![image](images/image_thumb_25255B3_25255D1.png)

which we can inject O2 into

![image](images/image_thumb_25255B4_25255D1.png)

And if I try to execute the **_PoC - Jni4Net - List JavaProperties.h2_** process, I get an unmanaged error (which is always a worse case scenario in the .NET Interop world)

![image](images/image_thumb_25255B6_25255D1.png)

As the (simpler script shows), the error happens on the  **_CreateJVM_** invocation

![image](images/image_thumb_25255B7_25255D1.png)

My next step was to create a local build of Jni4Net (which you saw on the preview note) and to use it to attach into an existing running ZAP with an O2 REPL injected.

Here is the moment when I have VisualStudio hooked, the script compiled (in the ZAP REPL), the jni4net dll loaded (with Symbols) in VisualStudio and a breakpoint on the CreateJVM method:

![image](images/image_thumb_25255B60_25255D.png)

Here is where I think the problem exists:

![image](images/image_thumb_25255B62_25255D.png)

the args object (created via JNI) seems to be empty.

It is then assigned to the value of the Jni4Net class path string

![image](images/image_thumb_25255B63_25255D.png)

The args object is used here:

![image](images/image_thumb_25255B64_25255D.png)

And inside that method, if I let **_args_** to be used, we will get the **_'Attempted to read or write protected memory'_** error

![image](images/image_thumb_25255B66_25255D.png)

but, if I change the execution path (manually) and set it to the line below (where no args is passed)

![image](images/image_thumb_25255B67_25255D.png)

Then the execution will be ok (note that the path with the &initArgs would had thrown an **_'Attempted to read or write protected memory'_**  by now):

![image](images/image_thumb_25255B68_25255D.png)

The only problem with this approach (which is basically not adding the classpath clue to the current JVM) is that unless we manually add the jni4net jar to the target app, we will get an exception here:

![image](images/image_thumb_25255B69_25255D.png)

i.e. br.handle would be 0 (meaning that the **_net.sf.jnin4net.Bridge_** class could not be found)

**Note AAA) Fixing the issue**

I added the **_Patch_IgnoreArgsInAttach_** property

![image](images/image_thumb_25255B71_25255D.png)

Which is then used here (to allow the selection of the path that works)

![image](images/image_thumb_25255B72_25255D.png)

I also changed the assembly name (so it is easy to track its use):

![image](images/image_thumb_25255B73_25255D.png)

After the compilation I copied it to the main target folder:

![image](images/image_thumb_25255B74_25255D.png)

To test it , I used the script

![image](images/image_thumb_25255B77_25255D.png)]

to start ZAP with a REPL, where I could execute OK:

![image](images/image_thumb_25255B76_25255D.png)

Final step is to create a zip of the bin folder

![image](images/image_thumb_25255B78_25255D.png)

Put it on a public [available location like DropBox](https://dl.dropboxusercontent.com/u/81532342/O2%20Files/jni4net-0.8.7.0-bin_Patched.zip)

Update the installer API to use that version:

![image](images/image_thumb_25255B79_25255D.png)

Update the API_Jni4Net.cs to use the jni4net.n-0.8.7.0_Patched.dll assembly (as seen below on first compile the referenced will be downloaded)

![image](images/image_thumb_25255B80_25255D.png)

once the compilation works:

![image](images/image_thumb_25255B81_25255D.png)

Running Jni4Net works locally

![image](images/image_thumb_25255B82_25255D.png)

And so does on 'injected into' java processes:

![image](images/image_thumb_25255B83_25255D.png)

Finally I can add a remote to the local repo:

![image](images/image_thumb_25255B85_25255D.png)

push it

![image](images/image_thumb_25255B86_25255D.png)

And confirm that the commits I did locally (with the patch)

![image](images/image_thumb_25255B87_25255D.png)

where pushed successfully:

![image](images/image_thumb_25255B88_25255D.png)


**NOTE ABC) Starting ZAP programmatically**

Here is a script that starts (and downloads on first run) the latest version of ZAP (return value is the new ZAP process, and ZAP's console out are being captured in the O2's LogViewer):

![image](images/image_thumb_25255B1_25255D1.png)

Here is the contents of the API_Zap.cs file (consumed above):

![image](images/image_thumb_25255B2_25255D1.png)

**Note #2) Setting default folders**

In this case I also had to update the location of the temp and O2.Platform.Scripts folder (usually not needed)

![image](images/image_thumb_25255B5_25255D1.png)
