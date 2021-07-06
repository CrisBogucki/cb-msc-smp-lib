read -r modules<../../modules
echo $modules
for mod in $modules
do
  echo "Generate for $mod module"
	./generate.sh -m $mod -t cs
done

echo " Generate complete!"


