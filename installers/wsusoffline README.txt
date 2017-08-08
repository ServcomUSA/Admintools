wsusoffline is covered by a GNU License.

You can review this license in \doc\license.txt inside the wsusoffline installation ZIP file.
----------------
Servcom USA Standard deployment instructions for wsusoffline:

1.	Create a shared folder on a file server:
	a.	KEEP THIS AWAY FROM REPLICATED NAMESPACES – do not put it under a Deployment share.
	b.	Share Name should be “WSUSOffline$” – this will keep it hidden from end users
	c.	You can allow Everyone read/write access to the folder
2.	From the server, run UpdateGenerator.exe to start downloading the updates. Try not to run the download during business hours.
	a.	Make sure to select both x86 and/or x64 versions of updates, as needed.
	b.	Select “Include C++ and .Net Frameworks” – these are usually needed
3.	Once the updates are seeded on the server, you need to access the share from a client machine.
	a.	From the client machine, browse the share you created earlier, and access the client subfolder.
	b.	Run UpdateInstaller.exe.
