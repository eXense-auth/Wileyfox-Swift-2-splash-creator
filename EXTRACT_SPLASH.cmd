@echo off
color 06
set file=%1
%~d0
cd "%~dp0"
if %file%=="" exit
RD /S /Q src\tmp >NUL 2>NUL
if not exist "src\tmp\" mkdir "src\tmp\"
if not exist "output\" mkdir "output\"
if not exist "output\extracted_logo\" mkdir "output\extracted_logo\"
echo.
echo.
echo.--------------------------------------------------
echo.	Wileyfox Swift 2 Splash Extractor 
echo.--------------------------------------------------
echo.	EXTRACTING SPLASH IMAGE 
echo.	and converting to .png picture 
echo.--------------------------------------------------
echo.
:: For other devices: http://forum.xda-developers.com/android/software-hacking/guide-how-to-create-custom-boot-logo-t3470473
echo.
echo.	Converting RLE to RAW file......
src\bin\CM_SPLASH_RGB24_converter -p 4 -w 720 -h 1280 -o 512 -d 1 < %file% > src\tmp\pic.raw 2>NUL
echo.
echo.	Converting RAW image to PNG file.....
src\bin\ffmpeg -loglevel quiet -hide_banner -f rawvideo -vcodec rawvideo -pix_fmt bgr24 -s 720x6832  -i src\tmp\pic.raw -vframes 1 -y "src\tmp\hd.png"
src\bin\ffmpeg -loglevel quiet -hide_banner -f rawvideo -vcodec rawvideo -pix_fmt bgr24 -s 1080x4480  -i src\tmp\pic.raw -vframes 1 -y "src\tmp\fhd.png"

src\bin\ffmpeg -loglevel quiet -y -i src\tmp\hd.png -filter:v "crop=720:1280:0:0" output\extracted_logo\splash_hd.png
src\bin\ffmpeg -loglevel quiet -y -i src\tmp\hd.png -filter:v "crop=720:1280:0:1280" output\extracted_logo\splash_fastboot.png
src\bin\ffmpeg -loglevel quiet -y -i src\tmp\hd.png -filter:v "crop=720:1280:0:2560" output\extracted_logo\splash_charge.png
src\bin\ffmpeg -loglevel quiet -y -i src\tmp\fhd.png -filter:v "crop=1080:1920:0:2560" output\extracted_logo\splash_fhd.png
echo.
echo.	Extraction Complete.
echo.	Picture can be found in output/extracted_logo folder
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
pause
RD /S /Q src\tmp
explorer .\output\extracted_logo
exit
