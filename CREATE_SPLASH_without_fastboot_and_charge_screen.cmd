@echo off
color 6f
set file=%1
%~d0
cd "%~dp0"
if %file%=="" exit
RD /S /Q src\tmp >NUL 2>NUL
if not exist "src\tmp\" mkdir "src\tmp\"
if not exist "output\" mkdir "output\"
echo.
echo.
echo.--------------------------------------------------
echo.	Wileyfox Swift 2 Splash Image Maker 
echo.--------------------------------------------------
echo.	CREATING SPLASH IMAGE  
echo.	and compressing to flashable .zip 
echo.--------------------------------------------------
echo.
:: For other devices: http://forum.xda-developers.com/android/software-hacking/guide-how-to-create-custom-boot-logo-t3470473
echo.
echo.	Converting Pictures to RAW files.....
src\bin\ffmpeg -hide_banner -loglevel -8 -y -i %file%		-f rawvideo -vcodec rawvideo -pix_fmt bgr24 -vf "scale=720:1280:force_original_aspect_ratio=increase,crop=720:1280,elbg=32" "src\tmp\pic1.raw" > NUL
::src\bin\ffmpeg -hide_banner -loglevel -8 -y -i src\2.png	-f rawvideo -vcodec rawvideo -pix_fmt bgr24 "src\tmp\pic2.raw" > NUL
::src\bin\ffmpeg -hide_banner -loglevel -8 -y -i src\3.png	-f rawvideo -vcodec rawvideo -pix_fmt bgr24 "src\tmp\pic3.raw" > NUL
src\bin\ffmpeg -hide_banner -loglevel -8 -y -i %file%		-f rawvideo -vcodec rawvideo -pix_fmt bgr24 -vf "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,elbg=32" "src\tmp\pic4.raw" > NUL
type src\tmp\pic*.raw > src\tmp\pic.raw 2>NUL
	if exist "src\tmp\pic.raw" (
		echo.
		) else (
			echo.
			echo.	PROCESS FAILED!!! RAW convert incorrect. Try Again.
			echo.
			echo.
			pause
			exit
		)
echo.
echo.	Splash screen creation.....
src\bin\CM_SPLASH_RGB24_converter -p 4 -w 720 -h 1280 -o 512 -e 1 < src\tmp\pic.raw > "src\tmp\pic.rle" 2>NUL
	for %%? in (src\tmp\pic.rle) do (set /a rlesize=%%~z?)
	if %rlesize% gtr 1228800 (call :warning)
src\bin\CM_SPLASH_RGB24_converter -p 5 -w 1080 -h 1920 -o 512 -e 1 < src\tmp\pic4.raw > "src\tmp\pic4.rle" 2>NUL
echo.
copy /Y src\tmp\pic.rle "output\splash.img" >NUL
src\bin\dd if=src\tmp\pic4.rle	"of=output\splash.img"	bs=64	seek=1	skip=1	count=7 2>NUL
src\bin\dd if=src\tmp\pic4.rle	"of=output\splash.img"	bs=32	seek=9	skip=1	count=1 2>NUL
src\bin\dd if=src\tmp\pic.rle	"of=output\splash.img"	bs=4	seek=79	skip=23	count=1 2>NUL
echo.
echo.fastboot flash splash splash.img > output\fastboot_flash_splash.cmd
	if exist "output\splash.img" (
		echo.
		echo.	Splash.img created in "output" folder
		echo.
		) else (
			echo.
			echo.	PROCESS FAILED.. Try Again&echo.
			echo.
			echo.
			pause
			exit
		)
echo.
echo.	Creating flashable ZIP.....
del /Q output\flashable_splash.zip >NUL 2>NUL
copy /Y src\bin\sample.zip output\flashable_splash.zip >NUL
cd output
..\src\bin\7za a flashable_splash.zip splash.img >NUL
cd..
echo.
if exist "output\flashable_splash.zip" (
	echo.
	echo.	Flashable zip file created in "output" folder.
	echo.	You can flash the flashable_splash.zip
	echo.	from any custom recovery like TWRP or CWM
	echo.
	) else (
		echo.
		echo.	Flashable ZIP not created..
		echo.
		echo.
	)
echo.
echo.
echo.	   /o/.                         `:+s    
echo.	   NMMMNy+.                  :sdMMMM/   
echo.	  -MMMMMMMMd+`            :yNMMMMMMMh   
echo.	  +MMMMMMMMMMMy.        +mMMMMMMMMMMN   
echo.	  oMMMMMMMMMms:`        .ohMMMMMMMMMM   
echo.	  +MMMMMMh+.               `:smMMMMMN   
echo.	  :MMms:                       .+hNMd   
echo.	  `/`                              -:   
echo.	   .--.`                       `..--    
echo.	   :MMMMMNdy+`            :sdmMMMMMh    
echo.	    /MMMMMMMMMs         -mMMMMMMMMh`    
echo.	     :NMMMMMMMM-        hMMMMMMMMy      
echo.	      .hMMMMMMMy       -MMMMMMMN/       
echo.	        /NMMMMMM.      hMMMMMMh.        
echo.	         `sMMMMMs     .MMMMMd:          
echo.	           .sMMMM`    yMMMd:            
echo.	             .sNMo   `MMd:              
echo.	               `om`  oh:                
echo.	                  `  `                  
echo.
echo.
echo.
echo.
pause
RD /S /Q src\tmp >NUL 2>NUL
explorer .\output
exit
:warning
echo.
echo.// // // // // // // // // // // // // // // // //
echo.	
echo.		!!! WARNING !!!
echo.	
echo.	THIS PICTURE IS INCORRECT 
echo.	FOR CREATING SPLASH SCREEN
echo.	
echo.// // // // // // // // // // // // // // // // //
echo.	
echo.	There are too many colors 
echo.	or color spots in the image.
echo.	
echo.// // // // // // // // // // // // // // // // //
echo.
echo.
pause
RD /S /Q src\tmp >NUL 2>NUL
exit
