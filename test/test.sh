echo "Bff Test"
echo " "
echo " "

if [[ $(pwd) =~ .*BrainfuckCompiler/? ]]
then
	cd test/
fi 

echo "########### TEST 1"
echo " "
../bin/bff -i brainfuck.b
if [ $? != 0 ]
then
	exit 1
fi

echo "########### TEST 2"
echo " "
../bin/bff -i brainfuck.wrong.b
if [ $? == 0 ]
then
	exit 1
fi



