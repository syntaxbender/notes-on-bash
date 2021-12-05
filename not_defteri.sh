#!/bin/bash
selection_key_note=-1
selection_key=-1

set_note(){
	clear
	echo "Not adını giriniz : "
	read -r not_adi
	if [ -w "./data/notes/$not_adi.dat" ]; then
		echo "Bu ada sahip bir not zaten var. Lütfen farklı bir dosya adı giriniz."
	else
		touch "./data/notes/$not_adi.dat"
		if [ ! -w "./data/notes/$not_adi.dat" ]; then
			echo "Not dosyası yazılamıyor."
			exit 1
		fi
		echo "Not içeriğini giriniz : "
		read -r not_icerigi
		echo "$not_icerigi" > "./data/notes/$not_adi.dat"
	fi
}
edit_note(){
	clear
	nano "./data/notes/$1.dat"
}
get_note(){
	while [[ ( $selection_key_note != "1" && $selection_key_note != "2" && $selection_key_note != "3" ) ]]; do
		clear
		echo -e "\n$1 isimdeki notunuz :"
		cat "./data/notes/$1.dat"
		echo -e "\nNotuzu silmek için (1)'e, düzenlemek için (2)'ye, geriye dönmek için (3)'e basınız."
		read -n 1 -r selection_key_note
		if [ $selection_key_note == "1" ]; then
			echo "testx"
			delete_note $1
			selection_key_note=-1
			list_notes
			break
		elif [ $selection_key_note == "2" ]; then
			echo "\naaaa\n"
			edit_note $1
			selection_key_note=-1
			list_notes
			break
		elif [ $selection_key_note == "3" ]; then
			selection_key_note=-1
			list_notes
			break
		fi
	done
}
delete_note(){
	clear
	rm "./data/notes/$1.dat"
	if [ -f "$FILE" ]; then
		echo "Not silinemedi."
	fi
}
list_notes(){
	clear
	count=1
	for entry in $(cd ./data/notes && ls -l *.dat | awk '{print $9}' | egrep -o '^([a-z0-9]+)')
	do
		echo -e "$count) $entry"
		((count++))
	done
	echo "Görüntülemek istediğiniz notun numarasını giriniz. Geri dönmek için 0'a basınız."
	read -r not_numarasi
	#echo $not_numarasi
	if [ $not_numarasi == "0" ]; then
		echo "a"
		notes_main
	else
		echo "b"
		get_note $(cd ./data/notes && ls -l *.dat | awk '{print $9}' | egrep -o '^([a-z0-9]+)' | sed -n "${not_numarasi}p")

	fi

}
notes_main(){
	while [[ ( $selection_key != "1" && $selection_key != "2" ) ]]; do
		clear
		echo -e "Lütfen seçeneklerden birisini seçiniz\n1) Notlarım\n2) Not Ekle\n\n"
		read -n 1 -s -r selection_key
		echo $selection_key
		if [ $selection_key == "1" ]; then
			list_notes
			selection_key=-1
		elif [ $selection_key == "2" ]; then
			set_note
			selection_key=-1
		fi
	done
}
if [ ! -d "./data" ]; then
	mkdir "data"
	if [ ! -d "./data" ]; then
		echo "Notları saklamak üzere dizin oluşturulamıyor."
		exit 1
	fi
fi
notes_main
