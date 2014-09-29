rm -f *.txt
cd ..\..
"c:\Program Files (x86)\Dymola 2014 FD01\bin\Dymola.exe" /nowindow Resources\Test\submodels.mos
cd Resources\Test
grep failed *.txt > allFailed.txt

