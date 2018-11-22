rm -f *.txt
cd ..\..
"c:\Program Files\Dymola 2019\bin64\Dymola.exe" /nowindow Resources\Test\submodels.mos
rem "c:\Program Files (x86)\Dymola 2015 FD01\bin\Dymola.exe" /nowindow Resources\Test\submodels.mos
cd Resources\Test
grep failed *.txt > allFailed.txt

