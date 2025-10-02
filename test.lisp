;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)



;;; ----------------------------------------------------------------------
;;; Generate test data


(defparameter *raw-surnames*
  '("Aág"
    "Aágh"
    "Aáron"
    "Abádi"
    "Abár"
    "Ábel"
    "Ábeles"
    "Ábelesz"
    "Ábelli"
    "Ábend"
    "Aberdán"
    "Aberer"
    "Aberle"
    "Aberman"
    "Abermann"
    "Abert"
    "Abért"
    "Aberth"
    "Abfal"
    "Abhof"
    "Abidovits"
    "Abis"
    "Abisch"
    "Ábisch"
    "Abkarovics"
    "Abl"
    "Ábl"
    "Abodi"
    "Abonyi"
    "Ábrányi"
    "Adamcsik"
    "Ádámcsik"
    "Adamich"
    "Adamis"
    "Ádler"
    "Adonics"
    "Adonyi"
    "Ady"
    "Agárdi"
    "Aggházy"
    "Ágh"
    "Agócs"
    "Ágoston"
    "Ajtay"
    "Alberth"
    "Almási"
    "Almássi"
    "Almássy"
    "Almásy"
    "Alpár"
    "Ama"
    "Amachel"
    "Amade"
    "Amadei"
    "Amadey"
    "Amadin"
    "Amadinger"
    "Aman"
    "Amán"
    "Áman"
    "Ámán"
    "Amancsia"
    "Amand"
    "Amann"
    "Amant"
    "Amar"
    "Amberger"
    "Ambich"
    "Ambrózfalvi"
    "Ambrózi"
    "Ambrózy"
    "Ambrus"
    "Ambrusics"
    "Ambrusik"
    "Ambruska"
    "Ambruzs"
    "Amelin"
    "Amena"
    "Ament"
    "Áment"
    "Amerán"
    "Amerand"
    "Amirás"
    "Ámirás"
    "Amisits"
    "Amlacher"
    "Amment"
    "Ammer"
    "Amon"
    "Ámon"
    "Amorth"
    "Amrik"
    "Amring"
    "Amthauzer"
    "Ámthor"
    "Amvein"
    "Amwel"
    "Amzel"
    "Ancsel"
    "Ányos"
    "Apáczai"
    "Áprily"
    "Arany"
    "Aranyi"
    "Arányi"
    "Aranykövi"
    "Aranykövy"
    "Aranyos"
    "Aranyosi"
    "Aranyoss"
    "Aranyossy"
    "Aranyosy"
    "Árkay"
    "Árva"
    "Árvai"
    "Avar"
    "Babits"
    "Bábolnai"
    "Bábolnay"
    "Bachman"
    "Bajza"
    "Bakos"
    "Bakucz"
    "Balassi"
    "Balázs"
    "Balduin"
    "Bálint"
    "Bán"
    "Bánffy"
    "Bánki"
    "Bánky"
    "Bánosi"
    "Bányai"
    "Bara"
    "Barabás"
    "Baránszky"
    "Baranyai"
    "Barát"
    "Baráth"
    "Bárczy"
    "Bárdosi"
    "Bárdy"
    "Báróczi"
    "Baróti"
    "Bársony"
    "Bartis"
    "Bartos"
    "Básti"
    "Batsányi"
    "Baumhorn"
    "Béky"
    "Bencsik"
    "Berda"
    "Berde"
    "Bereményi"
    "Berkes"
    "Berky"
    "Bertha"
    "Bertók"
    "Berzsenyi"
    "Bessenyei"
    "Bezerédj"
    "Birtalan"
    "Bitó"
    "Bitskey"
    "Blaha"
    "Bobula"
    "Bodócs"
    "Bodonyi"
    "Bodor"
    "Bodrogközy"
    "Bohuniczki"
    "Bohuniczky"
    "Borbát"
    "Borbáth"
    "Borbiró"
    "Bornemisza"
    "Bornemissza"
    "Boromissza"
    "Borszéki"
    "Borszéky"
    "Bozók"
    "Böhm"
    "Böjte"
    "Böjthe"
    "Bölöni"
    "Bölönyi"
    "Böszörményi"
    "Brandenburgi"
    "Brein"
    "Breuer"
    "Brodarics"
    "Bródy"
    "Brunnhuber"
    "Brunszvik"
    "Budai"
    "Bukovics"
    "Bulla"
    "Búzás"
    "Czárán"
    "Czene"
    "Czigler"
    "Czinka"
    "Czipauer"
    "Czipri"
    "Czóbel"
    "Czuczor"
    "Cságoly"
    "Csanádi"
    "Csaplár"
    "Csapó"
    "Csáth"
    "Csathó"
    "Cseke"
    "Csengei"
    "Csengey"
    "Cseres"
    "Cserna"
    "Cserzy"
    "Csesznegi"
    "Csete"
    "Csíkszentmihályi"
    "Csiky"
    "Csillag"
    "Csire"
    "Csiszér"
    "Csizmadia"
    "Csokonai"
    "Csoóri"
    "Csorba"
    "Csuka"
    "Csukás"
    "Csupó"
    "Dallos"
    "Dalos"
    "Dankó"
    "Dapsy"
    "Dayka"
    "Degré"
    "Dékány"
    "Derecskei"
    "Déry"
    "Devecseri"
    "Dévényi"
    "Dieschler"
    "Dobai"
    "Dobos"
    "Dobozy"
    "Domány"
    "Dombóvári"
    "Domján"
    "Domonkos"
    "Donászy"
    "Dorgó"
    "Doroghy"
    "Döbrentei"
    "Döbröczöni"
    "Dörgõ"
    "Dörnutz"
    "Drenker"
    "Dsida"
    "Dugonics"
    "Dukai"
    "Dummerling"
    "Dunakovácsi"
    "Düttrich"
    "Dvorák"
    "Egerszegi"
    "Egressy"
    "Ekler"
    "Emandity"
    "Ember"
    "Emõdi"
    "Emrich"
    "Eörsi"
    "Esterházy"
    "Esze"
    "Fábián"
    "Fabók"
    "Falcsik"
    "Faludi"
    "Faludy"
    "Farkas"
    "Farkasdy"
    "Fáy"
    "Fazekas"
    "Fedák"
    "Féja"
    "Fejes"
    "Fejtõ"
    "Fellner"
    "Fenyõ"
    "Ferencz"
    "Ferenczy"
    "Feszl"
    "Feszty"
    "Finta"
    "Fodor"
    "Foerk"
    "Fogarasi"
    "Forgách"
    "Forgács"
    "Földessy"
    "Földi"
    "Francsek"
    "Furmann"
    "Gaál"
    "Gacsal"
    "Gádor"
    "Galgóczi"
    "Galgóczy"
    "Gáli"
    "Galimberti"
    "Gáll"
    "Galla"
    "Garaczi"
    "Garai"
    "Garay"
    "Gárdonyi"
    "Gáspár"
    "Gáthi"
    "Gáthy"
    "Gáti"
    "Gazdag"
    "Gedó"
    "Gedõ"
    "Géher"
    "Gelléri"
    "Gémes"
    "Gérecz"
    "Gerencsér"
    "Gergei"
    "Gerle"
    "Gerster"
    "Geszti"
    "Geyer"
    "Giergl"
    "Gion"
    "Glatter"
    "Glatz"
    "Gobbi"
    "Goda"
    "Gorove"
    "Goszleth"
    "Gottgeb"
    "Gozsdu"
    "Göllner"
    "Göncz"
    "Görgey"
    "Gráber"
    "Grecsó"
    "Greguss"
    "Grendel"
    "Guczogi"
    "Gulácsy"
    "Gulyás"
    "Guzsik"
    "Gvadányi"
    "Gyarmathy"
    "Gyarmati"
    "Gyenge"
    "Gyergyai"
    "Gyóni"
    "Gyöngyösi"
    "Györgyi"
    "Gyõri"
    "Gyulai"
    "Gyurkó"
    "Gyurkovics"
    "Hajdu"
    "Hajnóczy"
    "Hámos"
    "Hampel"
    "Hamvas"
    "Handler"
    "Harcos"
    "Harkányi"
    "Határ"
    "Hatvany"
    "Hauszmann"
    "Havel"
    "Háy"
    "Hegedüs"
    "Hegedûs"
    "Heltai"
    "Herczeg"
    "Hernádi"
    "Hervay"
    "Hesz"
    "Hevesi"
    "Hevessi"
    "Hevessy"
    "Hevesy"
    "Hikisch"
    "Hild"
    "Hincz"
    "Hoepfner"
    "Hofhauser"
    "Hofrichter"
    "Hollós"
    "Hollósi"
    "Hollóssi"
    "Hollóssy"
    "Hollósvölgyi"
    "Hollósy"
    "Honthi"
    "Honthy"
    "Honti"
    "Honty"
    "Hornyák"
    "Hubay"
    "Hubert"
    "Hudetz"
    "Hugonnai"
    "Hunyady"
    "Hübner"
    "Hültl"
    "Hüvös"
    "Ignácz"
    "Ignotus"
    "Ilia"
    "Ilosvai"
    "Iluh"
    "Jablonszky"
    "Jagelló"
    "Jáhn"
    "Jámbor"
    "Janáky"
    "Janesch"
    "Janikovszky"
    "Jankovich"
    "Jankovics"
    "Jánosi"
    "Jánossi"
    "Jánossy"
    "Jánosy"
    "Jánszky"
    "Jászai"
    "Jedlicska"
    "Jékely"
    "Jobba"
    "Jobbágy"
    "Jósika"
    "Juhász"
    "Jurcsik"
    "Kabai"
    "Kacsa"
    "Kaffka"
    "Kalász"
    "Káldi"
    "Kállai"
    "Kállay"
    "Kallina"
    "Kallós"
    "Kálmán"
    "Kálnay"
    "Kálnoky"
    "Kalocsai"
    "Kalocsay"
    "Kampis"
    "Kányádi"
    "Karácsony"
    "Karády"
    "Karátson"
    "Karikás"
    "Karinthy"
    "Károli"
    "Kárpáthy"
    "Kárpáti"
    "Karvaly"
    "Kassák"
    "Kasselik"
    "Kauser"
    "Kazinczy"
    "Kébel"
    "Kebelei"
    "Kebeli"
    "Kebely"
    "Keberle"
    "Keberling"
    "Kéberling"
    "Kébert"
    "Kebisz"
    "Kébity"
    "Kecskési"
    "Kecskéssy"
    "Kecskésy"
    "Kelenyi"
    "Kelényi"
    "Keleti"
    "Kemenes"
    "Kémenes"
    "Kemény"
    "Kencze"
    "Kenczel"
    "Kendeffi"
    "Kendeffy"
    "Kender"
    "Kenderesi"
    "Kenderessi"
    "Kenderessy"
    "Kenderesy"
    "Kenesei"
    "Kenesey"
    "Képes"
    "Kerék"
    "Kerekes"
    "Kerékgyártó"
    "Kerényi"
    "Keresztes"
    "Keresztesi"
    "Keresztessi"
    "Keresztessy"
    "Keresztesy"
    "Kereszturi"
    "Keresztúri"
    "Keresztury"
    "Keresztúry"
    "Kéri"
    "Kerkovics"
    "Kerkovits"
    "Kertes"
    "Kertesházy"
    "Keserü"
    "Keserû"
    "Késmárki"
    "Késmárky"
    "Kesztenbaum"
    "Kéthly"
    "Kétly"
    "Ketskés"
    "Kézai"
    "Kézmárki"
    "Kézmárszky"
    "Kézsmárk"
    "Kézsmárki"
    "Kézsmárky"
    "Kézsmárszky"
    "Kígyós"
    "Kisfaludy"
    "Kittenberger"
    "Klacher"
    "Kóbor"
    "Kocsis"
    "Kodolányi"
    "Kolbenmeyer"
    "Kolozsvári"
    "Koltai"
    "Komáromi"
    "Komjáthy"
    "Konrád"
    "Kónya"
    "Kormos"
    "Kós"
    "Kosáry"
    "Kosztolányi"
    "Kotsis"
    "Kovai"
    "Kozán"
    "Kozma"
    "Kozmutza"
    "Kölcsey"
    "Körösfõi"
    "Körösi"
    "Kõrösi"
    "Körössi"
    "Körössy"
    "Kõrössy"
    "Körösy"
    "Kõrösy"
    "Krassó"
    "Krasznahorkai"
    "Kriegl"
    "Krúdy"
    "Kuczka"
    "Kukorelly"
    "Kukovetz"
    "Kulcsár"
    "Kulin"
    "Laborfalvi"
    "Ladányi"
    "Ladik"
    "Lajta"
    "Lampérth"
    "Lanczkor"
    "Láng"
    "Langer"
    "Lányi"
    "Lászlóffy"
    "Laszlovszky"
    "Latinovits"
    "Lator"
    "Lauber"
    "Lázár"
    "Lebstück"
    "Lechner"
    "Légmann"
    "Lénárd"
    "Leövey"
    "Lesznai"
    "Lévai"
    "Lévay"
    "Lezsák"
    "Limburszky"
    "Lohr"
    "Lomb"
    "Lorántffy"
    "Losonczi"
    "Lovik"
    "Löffler"
    "Löllbach"
    "Lõrincz"
    "Lõwy"
    "Lukovszky"
    "Lux"
    "Macskássy"
    "Madarass"
    "Madarassy"
    "Madarász"
    "Magyar"
    "Majthényi"
    "Makkai"
    "Makláry"
    "Makovecz"
    "Makovics"
    "Mallász"
    "Málnai"
    "Máltás"
    "Mándi"
    "Mándy"
    "Márai"
    "Marék"
    "Markó"
    "Markovits"
    "Márkus"
    "Márkutz"
    "Marosi"
    "Maróthi"
    "Maróthy"
    "Maróti"
    "Marsall"
    "Marschalkó"
    "Martsekényi"
    "Mayerhoffer"
    "Mazsaroff"
    "Mécs"
    "Meder"
    "Méder"
    "Medgyaszay"
    "Mednyánszky"
    "Megyesi"
    "Méhes"
    "Méhesi"
    "Méhessi"
    "Méhessy"
    "Méhesy"
    "Mellinger"
    "Mélykuti"
    "Mélykúti"
    "Mesterházi"
    "Meszlényi"
    "Mészöly"
    "Mezey"
    "Mézmenta"
    "Mikle"
    "Mikó"
    "Mikszáth"
    "Milványi"
    "Miskolczi"
    "Misoga"
    "Misztótfalusi"
    "Molter"
    "Moly"
    "Móra"
    "Móry"
    "Moss"
    "Murányi"
    "Muráth"
    "Muráti"
    "Nádas"
    "Nádasdi"
    "Nádasdy"
    "Nádasi"
    "Nádass"
    "Nádassy"
    "Nádler"
    "Nemere"
    "Nemes"
    "Németh"
    "Némethy"
    "Neogrády"
    "Nepp"
    "Neuschloss"
    "Nógrádi"
    "Nógrády"
    "Novák"
    "Nyergesi"
    "Nyergesy"
    "Nyilassi"
    "Nyilasy"
    "Nyírõ"
    "Obersovszky"
    "Oláh"
    "Oravecz"
    "Orczy"
    "Orosz"
    "Osvát"
    "Ozábal"
    "Ozabiner"
    "Ozáng"
    "Ozanic"
    "Ozanich"
    "Ozanics"
    "Ozánics"
    "Ozanits"
    "Ördögh"
    "Örsi"
    "Õz"
    "Õze"
    "Packh"
    "Paczolay"
    "Padányi"
    "Pálffi"
    "Pálffy"
    "Pálfi"
    "Pálfy"
    "Pálóczi"
    "Palotai"
    "Pályi"
    "Pan"
    "Pantheim"
    "Papp"
    "Pardi"
    "Parti"
    "Pártos"
    "Páskándi"
    "Passuth"
    "Pásztory"
    "Pataki"
    "Pataky"
    "Patartics"
    "Pató"
    "Pattantyús"
    "Pauer"
    "Paulheim"
    "Pázmány"
    "Péchy"
    "Pecz"
    "Pelényi"
    "Péntek"
    "Pénzes"
    "Perczel"
    "Petelei"
    "Péterffy"
    "Péterfi"
    "Péterfy"
    "Pethõ"
    "Petõcz"
    "Petri"
    "Petrõczy"
    "Petschacher"
    "Pfiffner"
    "Pilinszky"
    "Plesz"
    "Podmaniczky"
    "Pollack"
    "Pongrácz"
    "Pongrátz"
    "Poós"
    "Porgesz"
    "Pörcz"
    "Preisich"
    "Prielle"
    "Pucher"
    "Puhl"
    "Pulszky"
    "Quittner"
    "Rab"
    "Rácz"
    "Radnóti"
    "Rainer"
    "Rajz"
    "Rákóczi"
    "Rákos"
    "Rákosi"
    "Rakovszky"
    "Rapai"
    "Ráskai"
    "Ráskay"
    "Raszler"
    "Ray"
    "Reiss"
    "Reményik"
    "Rerrich"
    "Réth"
    "Réthi"
    "Réti"
    "Révész"
    "Reviczky"
    "Rideg"
    "Rimanóczy"
    "Rimay"
    "Ritoók"
    "Román"
    "Rómer"
    "Romhányi"
    "Rónay"
    "Roskovics"
    "Roskovits"
    "Rostás"
    "Rökk"
    "Rudolf"
    "Ruik"
    "Ruttkay"
    "Ruzicskay"
    "Salamin"
    "Salamon"
    "Salinger"
    "Salkaházi"
    "Samodai"
    "Sándorfi"
    "Sándy"
    "Sánta"
    "Sarkadi"
    "Sarkady"
    "Sárközi"
    "Sáros"
    "Sárosi"
    "Sárossi"
    "Sárossy"
    "Sárosy"
    "Sarusi"
    "Sásdi"
    "Sass"
    "Schannen"
    "Scheer"
    "Scheiber"
    "Schéner"
    "Schickedanz"
    "Schlachta"
    "Schmahl"
    "Schoefft"
    "Schoepf"
    "Schomann"
    "Schön"
    "Schulek"
    "Schusbek"
    "Sebõk"
    "Selymes"
    "Sík"
    "Siklósi"
    "Siklóssi"
    "Siklóssy"
    "Siklósy"
    "Simor"
    "Sinka"
    "Sipos"
    "Sípos"
    "Siposhegyi"
    "Sirató"
    "Sisa"
    "Sohonyai"
    "Solymosi"
    "Somlyó"
    "Somogyvári"
    "Somogyváry"
    "Sõtér"
    "Spiró"
    "Steindl"
    "Steinhardt"
    "Sterk"
    "Strobentz"
    "Sugár"
    "Suka"
    "Sulyok"
    "Sütõ"
    "Sváby"
    "Szabó"
    "Szakonyi"
    "Szálas"
    "Szálinger"
    "Szántó"
    "Száraz"
    "Szathmári"
    "Szathmáry"
    "Szatmári"
    "Szatmáry"
    "Szávay"
    "Széchenyi"
    "Szécsi"
    "Szeder"
    "Szelecki"
    "Szeleczki"
    "Szeleczky"
    "Szélesi"
    "Szenczi"
    "Szenczy"
    "Szendrey"
    "Szentkirályi"
    "Szentkuthy"
    "Szentmihályi"
    "Szepes"
    "Szigeti"
    "Szigligeti"
    "Sziklai"
    "Szilágyi"
    "Szili"
    "Szilvási"
    "Szilvássy"
    "Szilvásy"
    "Szini"
    "Sziráky"
    "Szita"
    "Szivesi"
    "Szivessi"
    "Szivessy"
    "Szivesy"
    "Szkalnitzky"
    "Szlukovényi"
    "Szomori"
    "Szomory"
    "Szõnyi"
    "Szörényi"
    "Szucsik"
    "Szunyoghy"
    "Tábori"
    "Takáts"
    "Tamkó"
    "Táncsics"
    "Tatay"
    "Techert"
    "Temesi"
    "Terebess"
    "Térey"
    "Ternovszky"
    "Tersánszky"
    "Thuróczy"
    "Thury"
    "Tinódi"
    "Tollas"
    "Tolnai"
    "Tolnay"
    "Tomkiss"
    "Tordai"
    "Torma"
    "Tormay"
    "Tornai"
    "Tót"
    "Tótfalusi"
    "Tóthfalusi"
    "Tóthi"
    "Tóthy"
    "Tóti"
    "Tõkés"
    "Törõcsik"
    "Török"
    "Tõry"
    "Tõzsér"
    "Turi"
    "Ulmann"
    "Ungár"
    "Unger"
    "Vadász"
    "Vágó"
    "Vajda"
    "Vállas"
    "Vámos"
    "Váradi"
    "Várady"
    "Várnai"
    "Varró"
    "Varsányi"
    "Vass"
    "Vastagh"
    "Vaszary"
    "Vay"
    "Végel"
    "Venczel"
    "Verancsics"
    "Verbõczy"
    "Veres"
    "Veress"
    "Verseghy"
    "Vészi"
    "Vesztróczy"
    "Vidor"
    "Vidovszky"
    "Vidra"
    "Virág"
    "Vitéz"
    "Vitkovics"
    "Vojnich"
    "Vörös"
    "Vörösmarty"
    "Wahorn"
    "Wass"
    "Weichinger"
    "Wellisch"
    "Weöres"
    "Wesselényi"
    "Wiegand"
    "Wieser"
    "Wittner"
    "Xántus"
    "Ybl"
    "Zágoni"
    "Zalán"
    "Zalaváry"
    "Závada"
    "Zay"
    "Zelk"
    "Zichy"
    "Zielinszky"
    "Zilahi"
    "Zilahy"
    "Zimándi"
    "Zinner"
    "Zitterbarth"
    "Zofahl"
    "Zöld"
    "Zrínyi"
    "Zrumeczky"
    "Zsignár"
    "Zsigrai"
    "Zsigray"
    "Zsoldos"
    "Zsolt"))


(defparameter *female-forenames*
  '("Abigél"
    "Adél"
    "Adrienn"
    "Ágnes"
    "Alexandra"
    "Alina"
    "Alíz"
    "Amira"
    "Andrea"
    "Anett"
    "Anikó"
    "Anita"
    "Anna"
    "Annabella"
    "Annamária"
    "Aranka"
    "Barbara"
    "Beáta"
    "Beatrix"
    "Bella"
    "Bernadett"
    "Bettina"
    "Bianka"
    "Bíborka"
    "Blanka"
    "Boglárka"
    "Borbála"
    "Boróka"
    "Brigitta"
    "Csenge"
    "Csilla"
    "Dalma"
    "Diána"
    "Dóra"
    "Dorina"
    "Dorka"
    "Dorottya"
    "Edina"
    "Edit"
    "Elena"
    "Elina"
    "Eliza"
    "Elizabet"
    "Emese"
    "Emili"
    "Emília"
    "Emma"
    "Enikõ"
    "Erika"
    "Erzsébet"
    "Eszter"
    "Etelka"
    "Éva"
    "Evelin"
    "Fanni"
    "Flóra"
    "Fruzsina"
    "Gabriella"
    "Gizella"
    "Gréta"
    "Gyöngyi"
    "Hajnalka"
    "Hanga"
    "Hanna"
    "Hédi"
    "Henrietta"
    "Ibolya"
    "Ildikó"
    "Ilona"
    "Irén"
    "Izabella"
    "Janka"
    "Jázmin"
    "Johanna"
    "Jolán"
    "Judit"
    "Júlia"
    "Julianna"
    "Kamilla"
    "Katalin"
    "Kiara"
    "Kincsõ"
    "Kinga"
    "Kitti"
    "Klára"
    "Klaudia"
    "Krisztina"
    "Lana"
    "Lara"
    "Laura"
    "Léna"
    "Letícia"
    "Lia"
    "Lili"
    "Liliána"
    "Lilien"
    "Lilla"
    "Linett"
    "Lívia"
    "Liza"
    "Lora"
    "Lotti"
    "Luca"
    "Lujza"
    "Magdolna"
    "Maja"
    "Margit"
    "Mária"
    "Marianna"
    "Márta"
    "Melinda"
    "Mia"
    "Milla"
    "Mira"
    "Mirabella"
    "Mirella"
    "Mónika"
    "Nara"
    "Natália"
    "Natasa"
    "Nazira"
    "Nikolett"
    "Nikoletta"
    "Nina"
    "Noémi"
    "Nóra"
    "Norina"
    "Odett"
    "Olívia"
    "Orsolya"
    "Panka"
    "Panna"
    "Petra"
    "Piroska"
    "Rebeka"
    "Regina"
    "Réka"
    "Renáta"
    "Rita"
    "Róza"
    "Rozália"
    "Rozina"
    "Rózsa"
    "Sára"
    "Szilvia"
    "Szofi"
    "Szofia"
    "Szófia"
    "Szonja"
    "Tamara"
    "Teréz"
    "Terézia"
    "Tímea"
    "Tünde"
    "Valéria"
    "Vanda"
    "Veronika"
    "Viktória"
    "Virág"
    "Vivien"
    "Zara"
    "Zejnep"
    "Zita"
    "Zoé"
    "Zora"
    "Zorka"
    "Zsanett"
    "Zselyke"
    "Zsófia"
    "Zsuzsanna"))


(defparameter *male-forenames*
  '("Ábel"
    "Ádám"
    "Adrián"
    "Ákos"
    "Albert"
    "Alex"
    "Alexander"
    "Andor"
    "András"
    "Antal"
    "Ármin"
    "Arnold"
    "Áron"
    "Árpád"
    "Attila"
    "Balázs"
    "Bálint"
    "Barna"
    "Barnabás"
    "Béla"
    "Bence"
    "Bende"
    "Bendegúz"
    "Benedek"
    "Benett"
    "Benjamin"
    "Benjámin"
    "Bertalan"
    "Boldizsár"
    "Botond"
    "Brájen"
    "Csaba"
    "Csanád"
    "Csongor"
    "Dániel"
    "Dávid"
    "Dénes"
    "Denisz"
    "Dezsõ"
    "Dominik"
    "Donát"
    "Dorián"
    "Eliot"
    "Endre"
    "Erik"
    "Ernõ"
    "Ervin"
    "Félix"
    "Ferenc"
    "Flórián"
    "Gábor"
    "Gellért"
    "Gergely"
    "Gergõ"
    "Géza"
    "Gusztáv"
    "György"
    "Gyõzõ"
    "Gyula"
    "Hunor"
    "Imre"
    "István"
    "Iván"
    "János"
    "Jenõ"
    "József"
    "Kálmán"
    "Károly"
    "Kende"
    "Kevin"
    "Kolos"
    "Kornél"
    "Kristóf"
    "Krisztián"
    "Krisztofer"
    "Lajos"
    "László"
    "Laurent"
    "Levente"
    "Marcell"
    "Márk"
    "Martin"
    "Márton"
    "Máté"
    "Mátyás"
    "Medox"
    "Merse"
    "Mihály"
    "Miklós"
    "Milán"
    "Mirkó"
    "Miron"
    "Nándor"
    "Nátán"
    "Nikolasz"
    "Nimród"
    "Noé"
    "Noel"
    "Nolen"
    "Norbert"
    "Olivér"
    "Ottó"
    "Pál"
    "Patrik"
    "Péter"
    "Richárd"
    "Róbert"
    "Roland"
    "Rudolf"
    "Sámuel"
    "Sándor"
    "Simon"
    "Soma"
    "Szabolcs"
    "Szilárd"
    "Szilveszter"
    "Tamás"
    "Teodor"
    "Tibor"
    "Vencel"
    "Vendel"
    "Viktor"
    "Vilmos"
    "Vince"
    "Zalán"
    "Zénó"
    "Zente"
    "Zétény"
    "Zoltán"
    "Zsigmond"
    "Zsolt"
    "Zsombor"))


(defparameter *settlements*
  '(("Budapest"          0.297085770)
    ("Debrecen"          0.331808738)
    ("Szeged"            0.359381037)
    ("Miskolc"           0.386841631)
    ("Pécs"              0.411801797)
    ("Gyõr"              0.433751541)
    ("Nyíregyháza"       0.453872793)
    ("Kecskemét"         0.472956513)
    ("Székesfehérvár"    0.489824689)
    ("Szombathely"       0.503032815)
    ("Szolnok"           0.515481481)
    ("Tatabánya"         0.526897725)
    ("Kaposvár"          0.537944286)
    ("Érd"               0.548722141)
    ("Sopron"            0.559151769)
    ("Veszprém"          0.569502896)
    ("Békéscsaba"        0.579817072)
    ("Zalaegerszeg"      0.589910563)
    ("Eger"              0.599195552)
    ("Nagykanizsa"       0.607482175)
    ("Dunaújváros"       0.615369657)
    ("Hódmezõvásárhely"  0.623067614)
    ("Dunakeszi"         0.630080355)
    ("Salgótarján"       0.636295152)
    ("Cegléd"            0.642447285)
    ("Baja"              0.648575749)
    ("Szigetszentmiklós" 0.654550959)
    ("Ózd"               0.660331026)
    ("Szekszárd"         0.666013861)
    ("Vác"               0.671714064)
    ("Gödöllõ"           0.677297965)
    ("Mosonmagyaróvár"   0.682762669)
    ("Hajdúböszörmény"   0.688134568)
    ("Pápa"              0.693503232)
    ("Gyula"             0.698815873)
    ("Gyöngyös"          0.704097693)
    ("Kiskunfélegyháza"  0.709132433)
    ("Ajka"              0.714078797)
    ("Orosháza"          0.718997915)
    ("Esztergom"         0.723859478)
    ("Szentes"           0.728705035)
    ("Kazincbarcika"     0.733515343)
    ("Kiskunhalas"       0.738300449)
    ("Budaörs"           0.742950180)
    ("Jászberény"        0.747515282)
    ("Siófok"            0.751847436)
    ("Szentendre"        0.756151154)
    ("Komló"             0.760249171)
    ("Nagykõrös"         0.764338673)
    ("Hajdúszoboszló"    0.768423408)
    ("Tata"              0.772463528)
    ("Makó"              0.776444391)
    ("Gyál"              0.780311334)
    ("Törökszentmiklós"  0.783903953)
    ("Hatvan"            0.787398999)
    ("Karcag"            0.790893705)
    ("Dunaharaszti"      0.794366785)
    ("Keszthely"         0.797837481)
    ("Várpalota"         0.801295406)
    ("Vecsés"            0.804728981)
    ("Békés"             0.808121688)
    ("Paks"              0.811438960)
    ("Komárom"           0.814708382)
    ("Dombóvár"          0.817955157)
    ("Fót"               0.821178092)
    ("Százhalombatta"    0.824341429)
    ("Oroszlány"         0.827462024)
    ("Göd"               0.830500373)
    ("Mohács"            0.833520843)
    ("Monor"             0.836530925)
    ("Balmazújváros"     0.839531642)
    ("Hajdúnánás"        0.842455050)
    ("Mátészalka"        0.845374372)
    ("Mezõtúr"           0.848288074)
    ("Szigethalom"       0.851188835)
    ("Csongrád"          0.854076995)
    ("Kisvárda"          0.856952725)
    ("Szarvas"           0.859812618)
    ("Tiszaújváros"      0.862648501)
    ("Mezõkövesd"        0.865482682)
    ("Kalocsa"           0.868301196)
    ("Dabas"             0.871111878)
    ("Gyömrõ"            0.873915748)
    ("Pomáz"             0.876716042)
    ("Veresegyház"       0.879497265)
    ("Balassagyarmat"    0.882231149)
    ("Tapolca"           0.884949878)
    ("Berettyóújfalu"    0.887574101)
    ("Sátoraljaújhely"   0.890179592)
    ("Pécel"             0.892754773)
    ("Püspökladány"      0.895310371)
    ("Sárvár"            0.897832594)
    ("Abony"             0.900347495)
    ("Mór"               0.902792240)
    ("Kiskõrös"          0.905227789)
    ("Pilisvörösvár"     0.907584157)
    ("Bonyhád"           0.909926903)
    ("Budakeszi"         0.912260964)
    ("Gyomaendrõd"       0.914591790)
    ("Balatonfüred"      0.916858759)
    ("Törökbálint"       0.919074985)
    ("Újfehértó"         0.921285081)
    ("Tiszavasvári"      0.923492622)
    ("Hajdúsámson"       0.925686540)
    ("Sárospatak"        0.927870753)
    ("Bátonyterenye"     0.930044238)
    ("Hajdúhadház"       0.932217382)
    ("Biatorbágy"        0.934369411)
    ("Nagykáta"          0.936510883)
    ("Sárbogárd"         0.938640775)
    ("Nyírbátor"         0.940752107)
    ("Albertirsa"        0.942826317)
    ("Kistarcsa"         0.944877539)
    ("Sajószentpéter"    0.946926717)
    ("Dorog"             0.948953930)
    ("Bicske"            0.950965476)
    ("Maglód"            0.952966805)
    ("Marcali"           0.954964729)
    ("Körmend"           0.956956011)
    ("Kõszeg"            0.958936055)
    ("Tiszafüred"        0.960914056)
    ("Üllõ"              0.962886777)
    ("Tiszakécske"       0.964854050)
    ("Kiskunmajsa"       0.966811957)
    ("Pilis"             0.968769865)
    ("Kisújszállás"      0.970722834)
    ("Tiszaföldvár"      0.972634594)
    ("Isaszeg"           0.974543460)
    ("Lajosmizse"        0.976448580)
    ("Barcs"             0.978351145)
    ("Tolna"             0.980253540)
    ("Celldömölk"        0.982153211)
    ("Nagyatád"          0.984012865)
    ("Heves"             0.985862813)
    ("Szigetvár"         0.987694201)
    ("Mezõberény"        0.989496810)
    ("Kapuvár"           0.991284435)
    ("Csorna"            0.993070527)
    ("Budakalász"        0.994849979)
    ("Sarkad"            0.996571193)
    ("Tököl"             0.998292067)
    ("Edelény"           1.000000000)))


(defparameter *foreign-settlements*
  '(("Kolozsvár"        "Cluj-Napoca"       "Románia"                 0.124127733)
    ("Temesvár"         "Timisoara"         "Románia"                 0.210477460)
    ("Nagyvárad"        "Oradea"            "Románia"                 0.280636613)
    ("Szatmárnémeti"    "Satu Mare"         "Románia"                 0.337141716)
    ("Arad"             "Arad"              "Románia"                 0.389815050)
    ("Marosvásárhely"   "Targu Mures"       "Románia"                 0.437361368)
    ("Újvidék"          "Novi Sad"          "Szerbia"                 0.473979049)
    ("Brassó"           "Brasov"            "Románia"                 0.507579887)
    ("Szabadka"         "Subotica"          "Szerbia"                 0.540576276)
    ("Zenta"            "Senta"             "Szerbia"                 0.568515810)
    ("Nagykároly"       "Carei"             "Románia"                 0.591522616)
    ("Nagybánya"        "Baia Mare"         "Románia"                 0.612732267)
    ("Csíkszereda"      "Miercurea Ciuc"    "Románia"                 0.633105406)
    ("Sepsiszentgyörgy" "Sfantu Gheorghe"   "Románia"                 0.652696000)
;    ("Baja"             "Baja"              "Szerbia"                 0.672043736)
    ("Szászrégen"       "Reghin"            "Románia"                 0.691116232)
    ("Topolya"          "Backa Topola"      "Szerbia"                 0.708645227)
    ("Magyarkanizsa"    "Kanjiza"           "Szerbia"                 0.725845013)
    ("Nagykõrös"        "Krizevci"          "Horvátország"            0.742888290)
    ("Székelyudvarhely" "Odorheiu Secuiesc" "Románia"                 0.759370295)
    ("Törökszentmiklós" "Sannicolau Mare"   "Románia"                 0.773995780)
    ("Szováta"          "Sovata"            "Románia"                 0.788259675)
    ("Becskerek"        "Zrenjanin"         "Szerbia"                 0.802226744)
    ("Nagybecskerek"    "Pancevo"           "Szerbia"                 0.814839201)
    ("Nagyszentmiklós"  "Sannicolau Mare"   "Románia"                 0.827030703)
    ("Zombor"           "Sombor"            "Szerbia"                 0.837403464)
    ("Lugos"            "Lugoj"             "Románia"                 0.847166380)
    ("Pancsova"         "Pancevo"           "Szerbia"                 0.856794374)
    ("Deszk"            "Deszk"             "Szerbia"                 0.866168717)
    ("Szilágycseh"      "Cehu Silvaniei"    "Románia"                 0.875008770)
    ("Bánlak"           "Banloc"            "Románia"                 0.883282153)
    ("Kiskõrös"         "Krizevci"          "Horvátország"            0.891533949)
    ("Nagyszalonta"     "Salonta"           "Románia"                 0.899235265)
    ("Szilágysomlyó"    "Simleu Silvaniei"  "Románia"                 0.905992131)
    ("Székelykeresztúr" "Cristuru Secuiesc" "Románia"                 0.912527726)
    ("Nagyõsz"          "Tomnatic"          "Románia"                 0.919047131)
    ("Szentanna"        "Santana"           "Románia"                 0.925453201)
    ("Törökkanizsa"     "Novi Knezevac"     "Szerbia"                 0.931735144)
    ("Magyarbóly"       "Bóly"              "Szerbia"                 0.937925340)
    ("Óbecse"           "Becej"             "Szerbia"                 0.943780931)
    ("Battonya"         "Battonya"          "Szerbia"                 0.949631125)
    ("Magyarlápos"      "Targu Lapus"       "Románia"                 0.955346397)
    ("Szabadfalva"      "Martinis"          "Románia"                 0.960370872)
    ("Magyarcsernye"    "Cernauti"          "Ukrajna"                 0.964785502)
    ("Nagysomkút"       "Sumuleu Ciuc"      "Románia"                 0.968978861)
    ("Kézdivásárhely"   "Targu Secuiesc"    "Románia"                 0.972950948)
    ("Nagypél"          "Pelisor"           "Románia"                 0.976847479)
    ("Tiszaszentmiklós" "Sannicolau Mare"   "Románia"                 0.980711630)
    ("Székelyhíd"       "Sacueni"           "Románia"                 0.984386890)
    ("Székelyvarság"    "Varsag"            "Románia"                 0.987662783)
    ("New York"         "New York"          "USA"                     0.990873913)
    ("Chicago"          "Chicago"           "USA"                     0.992746623)
    ("Los Angeles"      "Los Angeles"       "USA"                     0.993745042)
    ("Toronto"          "Toronto"           "Kanada"                  0.994716476)
    ("Cleveland"        "Cleveland"         "USA"                     0.995526005)
    ("Detroit"          "Detroit"           "USA"                     0.996114262)
    ("Miami"            "Miami"             "USA"                     0.996691726)
    ("Boston"           "Boston"            "USA"                     0.997091094)
    ("Montréal"         "Montréal"          "Kanada"                  0.997452683)
    ("Philadelphia"     "Philadelphia"      "USA"                     0.997787288)
    ("Sydney"           "Sydney"            "Ausztrália"              0.998035544)
    ("Melbourne"        "Melbourne"         "Ausztrália"              0.998283799)
    ("Vancouver"        "Vancouver"         "Kanada"                  0.998510467)
    ("London"           "London"            "Egyesült Királyság"      0.998715548)
    ("Berlin"           "Berlin"            "Németország"             0.998893644)
    ("München"          "München"           "Németország"             0.999039359)
    ("Brüsszel"         "Brussel"           "Belgium"                 0.999163487)
    ("Bécs"             "Wien"              "Ausztria"                0.999282218)
    ("Zürich"           "Zürich"            "Svájc"                   0.999395552)
    ("Sao Paulo"        "Sao Paulo"         "Brazília"                0.999508886)
    ("Buenos Aires"     "Buenos Aires"      "Argentína"               0.999595236)
    ("Johannesburg"     "Johannesburg"      "Dél-afrikai Köztársaság" 0.999670792)
    ("Párizs"           "Paris"             "Franciaország"           0.999740951)
    ("Amszterdam"       "Amsterdam"         "Hollandia"               0.999811110)
    ("Stockholm"        "Stockholm"         "Svédország"              0.999859682)
    ("Koppenhága"       "Kobenhavn"         "Dánia"                   0.999908253)
    ("Róma"             "Roma"              "Olaszország"             0.999951428)
    ("Madrid"           "Madrid"            "Spanyolország"           0.999978413)
    ("Tel-Aviv"         "Tel-Aviv"          "Izrael"                  1.000000000)))


(defparameter *institutions*
  '(("Bácsalmási Hunyadi János Gimnázium" "Bajai TK")
    ("Bácsalmási Körzeti Általános Iskola és Alapfokú Mûvészeti Iskola" "Bajai TK")
    ("Bácsalmási Körzeti Általános Iskola és Alapfokú Mûvészeti Iskola Kunbajai Általános Iskolája" "Bajai TK")
    ("Bácsalmási Körzeti Általános Iskola és Alapfokú Mûvészeti Iskola Madarasi Petõfi Sándor Általános Iskolája és Alapfokú Mûvészeti Iskolája" "Bajai TK")
    ("Bácskai Általános Iskola Katymári Tagintézménye" "Bajai TK")
    ("Bácskai Általános Iskola Tataházi Tagintézménye" "Bajai TK")
    ("Bajai Eötvös József Általános Iskola Telephelye" "Bajai TK")
    ("Bajai Liszt Ferenc Alapfokú Mûvészeti Iskola" "Bajai TK")
    ("Bajai Liszt Ferenc Alapfokú Mûvészeti Iskola Bezerédj Utcai Telephelye" "Bajai TK")
    ("Bajai Liszt Ferenc Alapfokú Mûvészeti Iskola Dózsa György Úti Telephelye" "Bajai TK")
    ("Bajai Liszt Ferenc Alapfokú Mûvészeti Iskola Érsekcsanádi Telephelye" "Bajai TK")
    ("Bajai Liszt Ferenc Alapfokú Mûvészeti Iskola Malom Utcai Telephelye" "Bajai TK")
    ("Bajai Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelés-oktatást Végzõ Iskola, Kollégium és Egységes Gyógypedagógiai Módszertani Intézmény" "Bajai TK")
    ("Bajai Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelés-oktatást Végzõ Iskola, Kollégium és Egységes Gyógypedagógiai Módszertani Intézmény Szegedi út 10. alatti telephelye" "Bajai TK")
    ("Bajai Szentistváni Általános Iskola Arany János Tagintézménye" "Bajai TK")
    ("Dávodi Forrás Általános Iskola" "Bajai TK")
    ("Dávodi Forrás Általános Iskola Csátaljai Tagintézményi Telephelye" "Bajai TK")
    ("Dunapataji Kodály Zoltán Általános Iskola és Alapfokú Mûvészeti Iskola Ordasi Telephelye" "Bajai TK")
    ("Dusnok-Fajsz Általános Iskola Fajszi Általános Iskolája" "Bajai TK")
    ("Érsekcsanádi Bíber János Általános Iskola - NAPKÖZI" "Bajai TK")
    ("Kalocsai Eperföldi Sportiskolai Általános Iskola" "Bajai TK")
    ("Kalocsai Fényi Gyula Általános Iskola" "Bajai TK")
    ("Kalocsai Fényi Gyula Általános Iskola Dunaszentbenedeki Telephelye" "Bajai TK")
    ("Kalocsai Fényi Gyula Általános Iskola Öregcsertõi Telephelye" "Bajai TK")
    ("Kalocsai Liszt Ferenc Alapfokú Mûvészeti Iskola" "Bajai TK")
    ("Kalocsai Liszt Ferenc Alapfokú Mûvészeti Iskola Dusnok Telephelye" "Bajai TK")
    ("Kalocsai Liszt Ferenc Alapfokú Mûvészeti Iskola Hajós Telephelye" "Bajai TK")
    ("Kalocsai Liszt Ferenc Alapfokú Mûvészeti Iskola Szent István király úti telephelye" "Bajai TK")
    ("Kalocsai Nebuló EGYMI Hosszú Antal Utcai Telephelye" "Bajai TK")
    ("Kalocsai Nebuló EGYMI Zrínyi Miklós utcai Telephelye" "Bajai TK")
    ("Miskei Tóth Menyhért Általános Iskola" "Bajai TK")
    ("Solti Vécsey Károly Általános Iskola és Alapfokú Mûvészeti Iskola Nagymajori Úti Telephelye" "Bajai TK")
    ("Sugovica Sportiskolai Általános Iskola" "Bajai TK")
    ("Sugovica Sportiskolai Általános Iskola Vöröskereszt Téri Telephelye" "Bajai TK")
    ("Szeremle-Dunafalva Általános Iskola Dunafalvai Telephelye" "Bajai TK")
    ("Balassagyarmati Balassi Bálint Gimnázium" "Balassagyarmati TK")
    ("Balassagyarmati Szabó Lõrinc Általános Iskola" "Balassagyarmati TK")
    ("Berceli Széchenyi István Általános Iskola Galgagutai Telephely" "Balassagyarmati TK")
    ("Berceli Széchenyi István Általános Iskola Nógrádsápi Tagintézménye" "Balassagyarmati TK")
    ("Börzsöny Általános Iskola" "Balassagyarmati TK")
    ("Dejtári Mikszáth Kálmán Általános Iskola Telephelye" "Balassagyarmati TK")
    ("Endrefalvai Móra Ferenc Általános Iskola" "Balassagyarmati TK")
    ("Endrefalvai Móra Ferenc Általános Iskola Szécsényfelfalui Telephelye" "Balassagyarmati TK")
    ("Érsekvadkerti Petõfi Sándor Általános Iskola Rákóczi úti Telephelye" "Balassagyarmati TK")
    ("II. Rákóczi Ferenc Általános Iskola Hollókõi Telephelye" "Balassagyarmati TK")
    ("Madách Imre Kollégium" "Balassagyarmati TK")
    ("Magyargéci Gárdonyi Géza Általános Iskola Sóshartyáni Telephelye" "Balassagyarmati TK")
    ("Mosoly EGYMI Móricz Zsigmond úti telephelye" "Balassagyarmati TK")
    ("Mosoly EGYMI Szontágh Pál utcai telephelye" "Balassagyarmati TK")
    ("Nógrádmegyeri Mikszáth Kálmán Általános Iskola" "Balassagyarmati TK")
    ("Nõtincsi Általános Iskola Keszegi Telephelye" "Balassagyarmati TK")
    ("Ráday Gedeon Általános Iskola" "Balassagyarmati TK")
    ("Rétsági Általános Iskola Tolmácsi Telephelye" 	"Balassagyarmati TK")
    ("Rimóci Szent István Általános Iskola Hunyadi Utcai Telephelye" "Balassagyarmati TK")
    ("Romhányi II. Rákóczi Ferenc Általános Iskola Kossuth úti Telephelye Alsó tagozatos osztályok" "Balassagyarmati TK")
    ("Rózsavölgyi Márk Alapfokú Mûvészeti Iskola Balassagyarmat, Ady Endre úti Telephelye" "Balassagyarmati TK")
    ("Rózsavölgyi Márk Alapfokú Mûvészeti Iskola Balassagyarmat, Dózsa György utcai Telephelye" "Balassagyarmati TK")
    ("Rózsavölgyi Márk Alapfokú Mûvészeti Iskola Balassagyarmat, Rákóczi fejedelem úti Telephelye" "Balassagyarmati TK")
    ("Rózsavölgyi Márk Alapfokú Mûvészeti Iskola Berceli Telephelye" "Balassagyarmati TK")
    ("Rózsavölgyi Márk Alapfokú Mûvészeti Iskola Érsekvadkerti Telephelye,Eötvös út 1" 	"Balassagyarmati TK")
    ("Rózsavölgyi Márk Alapfokú Mûvészeti Iskola Nógrádi Telephelye" "Balassagyarmati TK")
    ("Rózsavölgyi Márk Alapfokú Mûvészeti Iskola Rétsági Telephelye, Iskola tér 1" 	"Balassagyarmati TK")
    ("Rózsavölgyi Márk Alapfokú Mûvészeti Iskola Szügyi Telephelye" "Balassagyarmati TK")
    ("Szügyi Madách Imre Általános Iskola" "Balassagyarmati TK")
    ("Tereskei Általános Iskola Telephelye" "Balassagyarmati TK")
    ("Varsányi Alapfokú Mûvészeti Iskola endrefalvai telephelye" "Balassagyarmati TK")
    ("Varsányi Alapfokú Mûvészeti Iskola nógrádmegyeri telephelye" "Balassagyarmati TK")
    ("Varsányi Alapfokú Mûvészeti Iskola Szécsény, Magyar úti telephelye" "Balassagyarmati TK")
    ("Varsányi Hunyadi Mátyás Általános Iskola" "Balassagyarmati TK")
    ("Varsányi Hunyadi Mátyás Általános Iskola õrhalmi telephely" "Balassagyarmati TK")
    ("Balatonfüredi Fekete István Általános Iskola, Egységes Gyógypedagógiai Módszertani Intézmény" "Balatonfüredi TK")
    ("Batsányi János Gimnázium és Kollégium" "Balatonfüredi TK")
    ("Bozzay Pál Német Nemzetiségi Nyelvoktató Általános Iskola" "Balatonfüredi TK")
    ("Csabrendeki Általános Iskola József Attila utcai Telephelye" "Balatonfüredi TK")
    ("Csontváry Általános Iskola" "Balatonfüredi TK")
    ("Ferencsik János Zeneiskola - Alapfokú Mûvészeti Iskola Csopaki Telephely" "Balatonfüredi TK")
    ("Gógánfai Fekete István Általános Iskola Dabronci Telephelye" "Balatonfüredi TK")
    ("Kisfaludy Sándor Gimnázium, Kollégium és Alapfokú Mûvészeti Iskola Csabrendeki telephely" "Balatonfüredi TK")
    ("Kisfaludy Sándor Gimnázium, Kollégium és Alapfokú Mûvészeti Iskola Gógánfai telephely" "Balatonfüredi TK")
    ("Kisfaludy Sándor Gimnázium, Kollégium és Alapfokú Mûvészeti Iskola Sümegi Telephely" "Balatonfüredi TK")
    ("Lesence Völgye Általános Iskola" "Balatonfüredi TK")
    ("Lóczy Lajos Gimnázium" 	"Balatonfüredi TK")
    ("Mûvészetek Völgye Általános Iskola" "Balatonfüredi TK")
    ("Mûvészetek Völgye Általános Iskola Telephelye" "Balatonfüredi TK")
    ("Ramassetter Vince Testnevelési Általános Iskola" "Balatonfüredi TK")
    ("Révfülöpi Általános Iskola" "Balatonfüredi TK")
    ("Szász Márton Általános Iskola és Fejlesztõ Nevelés-Oktatást Végzõ Iskola" "Balatonfüredi TK")
    ("Tapolcai Bárdos Lajos Általános Iskola" "Balatonfüredi TK")
    ("Tapolcai Járdányi Pál Zeneiskola-Alapfokú Mûvészeti Iskola" "Balatonfüredi TK")
    ("Tapolcai Járdányi Pál Zeneiskola-Alapfokú Mûvészeti Iskola Lesenceistvándi Telephelye" "Balatonfüredi TK")
    ("Tapolcai Kazinczy Ferenc Általános Iskola" "Balatonfüredi TK")
    ("Tatay Sándor Általános Iskola Nemesgulácsi Keresztury Dezsõ Tagiskolája" "Balatonfüredi TK")
    ("Balsaráti Vitus János Általános Iskola Tavasz Utcai Telephelye" "Békéscsabai TK")
    ("Békés Vármegyei Pedagógiai Szakszolgálat Békéscsabai Tagintézménye" "Békéscsabai TK")
    ("Békés Vármegyei Pedagógiai Szakszolgálat Békéscsabai Tagintézményének Pásztor utcai Telephelye" "Békéscsabai TK")
    ("Békés Vármegyei Pedagógiai Szakszolgálat Békési Tagintézményének Mezõberényi Telephelye" "Békéscsabai TK")
    ("Békés Vármegyei Pedagógiai Szakszolgálat Gyomaendrõdi Tagintézményének Dévaványai Telephelye" "Békéscsabai TK")
    ("Békés Vármegyei Pedagógiai Szakszolgálat Gyulai Tagintézményének Eleki Telephelye" "Békéscsabai TK")
    ("Békés Vármegyei Pedagógiai Szakszolgálat Orosházi Tagintézménye" "Békéscsabai TK")
    ("Békés Vármegyei Pedagógiai Szakszolgálat Szarvasi Tagintézménye" "Békéscsabai TK")
    ("Békés Vármegyei Pedagógiai Szakszolgálat Szeghalmi Tagintézményének Füzesgyarmati Telephelye" "Békéscsabai TK")
    ("Békés Vármegyei Pedagógiai Szakszolgálat Szeghalmi Tagintézményének Vésztõi Telephelye" "Békéscsabai TK")
    ("Békéscsabai Bartók Béla Mûvészeti Szakgimnázium és Alapfokú Mûvészeti Iskola" "Békéscsabai TK")
    ("Békéscsabai Bartók Béla Mûvészeti Szakgimnázium és Alapfokú Mûvészeti Iskola Csorvás Rákóczi Utcai Telephelye" 	"Békéscsabai TK")
    ("Békéscsabai Bartók Béla Mûvészeti Szakgimnázium és Alapfokú Mûvészeti Iskola Gerendási Telephelye" "Békéscsabai TK")
    ("Békéscsabai Bartók Béla Szakgimnázium és Alapfokú Mûvészeti Iskola Telekgerendási Telephelye" "Békéscsabai TK")
    ("Békéscsabai Kazinczy Ferenc Általános Iskola" "Békéscsabai TK")
    ("Békéssámsoni Általános Iskola" "Békéscsabai TK")
    ("Bereczki Máté Általános Iskola Árpád utca 68. szám alatti telephelye" "Békéscsabai TK")
    ("Chován Kálmán Alapfokú Mûvészeti Iskola" "Békéscsabai TK")
    ("Chován Kálmán Alapfokú Mûvészeti Iskola Kondoros, Hõsök úti telephely" "Békéscsabai TK")
    ("Chován Kálmán Alapfokú Mûvészeti Iskola Öcsödi Telephelye" "Békéscsabai TK")
    ("Csabacsûdi Trefort Ágoston Általános Iskola" "Békéscsabai TK")
    ("Csabacsûdi Trefort Ágoston Általános Iskola Iskola u. 9. alatti telephelye" "Békéscsabai TK")
    ("Csorvási Gulyás Mihály Általános Iskola Petõfi Sándor Utcai Telephelye" "Békéscsabai TK")
    ("Dobozi Általános Iskola" "Békéscsabai TK")
    ("Erzsébethelyi Általános Iskola Telephelye" "Békéscsabai TK")
    ("Esély Pedagógiai Központ Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Kollégium és Egységes Gyógypedagógiai Módszertani Intézmény" "Békéscsabai TK")
    ("Esély Pedagógiai Központ Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Kollégium és Egységes Gyógypedagógiai Módszertani Intézmény Magyarbánhegyesi Tagintézménye" "Békéscsabai TK")
    ("Esély Pedagógiai Központ Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Kollégium és Egységes Gyógypedagógiai Módszertani Intézmény Magyarbánhegyesi Tagintézményének Damjanich Utcai Telephelye" "Békéscsabai TK")
    ("Gerlai Általános Iskola" "Békéscsabai TK")
    ("Jankay Tibor Két Tanítási Nyelvû Általános Iskola Dedinszky Gyula utcai Telephelye" "Békéscsabai TK")
    ("Jankó János Általános Iskola és Gimnázium" "Békéscsabai TK")
    ("Kondorosi Petõfi István Általános Iskola és Kollégium" "Békéscsabai TK")
    ("Lencsési Általános Iskola" 	"Békéscsabai TK")
    ("Magyarbánhegyesi Kossuth Lajos Általános Iskola" "Békéscsabai TK")
    ("Mezõhegyesi József Attila Általános Iskola és Kollégium" 	"Békéscsabai TK")
    ("Mezõkovácsházi Alapfokú Mûvészeti Iskola" "Békéscsabai TK")
    ("Mezõkovácsházi Hunyadi János Általános Iskola, Gimnázium és Kollégium" "Békéscsabai TK")
    ("Mezõkovácsházi Hunyadi János Általános Iskola, Gimnázium Kollégiumi Telephelye (Mezõkovácsháza" 	"Békéscsabai TK")
    ("Nagyszénási Czabán Samu Általános Iskola Telephelye" "Békéscsabai TK")
    ("Orosházi Liszt Ferenc Alapfokú Mûvészeti Iskola Ady Endre utcai Telephelye" "Békéscsabai TK")
    ("Orosházi Liszt Ferenc Alapfokú Mûvészeti Iskola Eötvös téri Telephelye" "Békéscsabai TK")
    ("Orosházi Liszt Ferenc Alapfokú Mûvészeti Iskola Medgyesegyháza Luther utcai Telephelye" "Békéscsabai TK")
    ("Orosházi Liszt Ferenc Alapfokú Mûvészeti Iskola Nagyszénás Táncsics utcai Telephelye" "Békéscsabai TK")
    ("Orosházi Liszt Ferenc Alapfokú Mûvészeti Iskola Orosháza Kossuth utcai Telephelye" "Békéscsabai TK")
    ("Orosházi Liszt Ferenc Alapfokú Mûvészeti Iskola Szabó Dezsõ utcai Telephelye" "Békéscsabai TK")
    ("Orosházi Táncsics Mihály Gimnázium és Kollégium Táncsics Mihály Utcai Telephelye" "Békéscsabai TK")
    ("Orosházi Vörösmarty Mihály Általános Iskola" "Békéscsabai TK")
    ("Orosházi Vörösmarty Mihály Általános Iskola Rákóczitelepi Tagintézménye" "Békéscsabai TK")
    ("TMKIT Vörösmarty Mihály Tagintézmény - Rákóczitelep" "Békéscsabai TK")
    ("Tótkomlósi Alapfokú Mûvészeti Iskola Battonya, Fõ utca 70-72 szám alatti telephelye" "Békéscsabai TK")
    ("Tótkomlósi Alapfokú Mûvészeti Iskola Békéssámsoni Telephelye" "Békéscsabai TK")
    ("Tótkomlósi Alapfokú Mûvészeti Iskola Mezõhegyesi Tagintézménye" "Békéscsabai TK")
    ("Tótkomlósi Alapfokú Mûvészeti Iskola Mezõhegyesi Tagintézménye Dombegyházi Telephelye" "Békéscsabai TK")
    ("Tótkomlósi Alapfokú Mûvészeti Iskola Tótkomlós Földvári úti telephelye" "Békéscsabai TK")
    ("Újkígyósi Széchenyi István Általános Iskola" "Békéscsabai TK")
    ("Budapest V. Kerületi Eötvös József Gimnázium" "Belsõ-Pesti TK")
    ("Budapest V. Kerületi Szabolcsi Bence Zenei Alapfokú Mûvészeti Iskola" "Belsõ-Pesti TK")
    ("Budapest V. Kerületi Szabolcsi Bence Zenei Alapfokú Mûvészeti Iskola Szemere u. 3. telephelye" "Belsõ-Pesti TK")
    ("Budapest V. Kerületi Szent István Magyar-Angol Két Tanítási Nyelvû Általános Iskola" "Belsõ-Pesti TK")
    ("Budapest VI. Kerület Bajza Utcai Általános Iskola" "Belsõ-Pesti TK")
    ("Budapest VI. Kerület Bajza Utcai Általános Iskola Bajza utca 68. alatti telephelye" "Belsõ-Pesti TK")
    ("Budapest VI. Kerületi Derkovits Gyula Általános Iskola Telephelye" "Belsõ-Pesti TK")
    ("Budapest VI. Kerületi Kölcsey Ferenc Gimnázium" "Belsõ-Pesti TK")
    ("Budapest VII. Kerületi Baross Gábor Általános Iskola" "Belsõ-Pesti TK")
    ("Budapest VIII. Kerületi Németh László Általános Iskola József utcai Telephelye" "Belsõ-Pesti TK")
    ("Budapesti Bárczi Gusztáv Óvoda, Általános Iskola és Készségfejlesztõ Iskola" "Belsõ-Pesti TK")
    ("Budapesti Fazekas Mihály Gyakorló Általános Iskola és Gimnázium" "Belsõ-Pesti TK")
    ("Budapesti V. Kerületi Szabolcsi Bence Zenei Alapfokú Mûvészeti Iskola Szemere u. 5. telephelye" "Belsõ-Pesti TK")
    ("Deák Diák Ének-zenei Általános Iskola és Gimnázium" "Belsõ-Pesti TK")
    ("Deák Diák Ének-zenei Általános Iskola és Gimnázium Bauer Sándor Utcai Tagintézményének Telephelye" "Belsõ-Pesti TK")
    ("Erzsébetvárosi Magyar-Angol Két Tanítási Nyelvû Általános Iskola és Mûvészeti Szakgimnázium Dob u. 85.Telephelye" "Belsõ-Pesti TK")
    ("Ferenczy Noémi Középiskolai Leánykollégium" "Belsõ-Pesti TK")
    ("Józsefvárosi Egységes Gyógypedagógiai Módszertani Intézmény és Általános Iskola" "Belsõ-Pesti TK")
    ("Józsefvárosi Zeneiskola Alapfokú Mûvészeti Iskola Horváth Mihály tér 8. Telephelye" "	Belsõ-Pesti TK")
    ("Józsefvárosi Zeneiskola Alapfokú Mûvészeti Iskola Losonci tér 1. Telephelye" "	Belsõ-Pesti TK")
    ("Józsefvárosi Zeneiskola Alapfokú Mûvészeti Iskola Somogyi Béla u. 9-15. Telephelye" "	Belsõ-Pesti TK")
    ("Losonci Téri Általános Iskola" "Belsõ-Pesti TK")
    ("Molnár Antal Zeneiskola - Alapfokú Mûvészeti Iskola Dob utcai Telephelye" "Belsõ-Pesti TK")
    ("Molnár Antal Zeneiskola - Alapfokú Mûvészeti Iskola Kertész utcai Telephelye" "Belsõ-Pesti TK")
    ("Molnár Antal Zeneiskola - Alapfokú Mûvészeti Iskola Rózsák terei Telephelye" "Belsõ-Pesti TK")
    ("Molnár Antal Zeneiskola-Alapfokú Mûvészeti Iskola" "Belsõ-Pesti TK")
    ("Terézvárosi Magyar-Angol, Magyar-Német Két Tannyelvû Általános Iskola" "Belsõ-Pesti TK")
    ("Tóth Aladár Zeneiskola Alapfokú Mûvészeti Iskola Bajza Utcai Telephelye" "Belsõ-Pesti TK")
    ("Tóth Aladár Zeneiskola Alapfokú Mûvészeti Iskola Pethõ Utcai Telephelye" "Belsõ-Pesti TK")
    ("Tóth Aladár Zeneiskola Alapfokú Mûvészeti Iskola Szív utca 6. Telephelye" "Belsõ-Pesti TK")
    ("Tóth Aladár Zeneiskola Alapfokú Mûvészeti Iskola Városligeti fasor 4. Telephelye" "Belsõ-Pesti TK")
    ("Vajda Péter Ének-zenei Általános és Sportiskola" "Belsõ-Pesti TK")
    ("Veres Pálné Gimnázium Telephelye (tornaterem" "Belsõ-Pesti TK")
    ("Barsi Dénes Általános Iskola" "Berettyóújfalui TK")
    ("Berekböszörményi Kossuth Lajos Általános Iskola" "Berettyóújfalui TK")
    ("Berettyóújfalui II. Rákóczi Ferenc Általános Iskola" "Berettyóújfalui TK")
    ("Berettyóújfalui József Attila Általános Iskola" "Berettyóújfalui TK")
    ("Bihari Alapfokú Mûvészeti Iskola" "Berettyóújfalui TK")
    ("Bihari Alapfokú Mûvészeti Iskola Esztár Kossuth utcai telephelye" "Berettyóújfalui TK")
    ("Bihari Alapfokú Mûvészeti Iskola Komádi Fõ u. 10-18. alatti telephelye" "Berettyóújfalui TK")
    ("Bihari Alapfokú Mûvészeti Iskola Zsákai telephelye" "Berettyóújfalui TK")
    ("Biharkeresztesi Bocskai István Általános Iskola Bocskai István Tagiskolája" "Berettyóújfalui TK")
    ("Biharkeresztesi Bocskai István Általános Iskola Kismarjai Bocskai István Tagiskolája" "Berettyóújfalui TK")
    ("Biharkeresztesi Bocskai István Általános Iskola Petõfi Sándor Tagiskolája" "Berettyóújfalui TK")
    ("Csenki Imre Alapfokú Mûvészeti Iskola" "Berettyóújfalui TK")
    ("Csenki Imre Alapfokú Mûvészeti Iskola Biharnagybajom, Bacsó Béla utca 2-4. szám alatti Telephelye" "Berettyóújfalui TK")
    ("Csenki Imre Alapfokú Mûvészeti Iskola Karcagi utca 28. szám alatti Telephelye" "Berettyóújfalui TK")
    ("Csenki Imre Alapfokú Mûvészeti Iskola Petõfi utca 9. szám alatti Telephelye" "Berettyóújfalui TK")
    ("Csenki Imre Alapfokú Mûvészeti Iskola Sárrétudvari, Erzsébet utca 1. szám alatti Telephelye" "Berettyóújfalui TK")
    ("Csenki Imre Alapfokú Mûvészeti IskolaBáránd, Kossuth utca 53-55. szám alatti Telephelye" "Berettyóújfalui TK")
    ("Csökmõi Bocskai István Általános Iskola Kossuth utcai Telephelye" "Berettyóújfalui TK")
    ("Derecskei Alapfokú Mûvészeti Iskola Derecske Lengyel utcai telephelye" "Berettyóújfalui TK")
    ("Derecskei Alapfokú Mûvészeti Iskola Létavértesi telephelye" "Berettyóújfalui TK")
    ("Derecskei Alapfokú Mûvészeti Iskola Tépei telephelye" "Berettyóújfalui TK")
    ("Derecskei Bocskai István Általános Iskola II. Rákóczi Ferenc Tagiskolája" "Berettyóújfalui TK")
    ("Derecskei Bocskai István Általános Iskola Lengyel Utcai Telephelye" "Berettyóújfalui TK")
    ("Derecskei I. Rákóczi György Gimnázium, Technikum és Kollégium" "Berettyóújfalui TK")
    ("Diószegi Lajos Általános Iskola" "Berettyóújfalui TK")
    ("Ebesi Arany János Magyar-Angol Két Tanítási Nyelvû Általános Iskola" "Berettyóújfalui TK")
    ("Éltes Mátyás Általános Iskola és Kollégium Egységes Gyógypedagógiai Módszertani Intézmény" "Berettyóújfalui TK")
    ("Földesi Karácsony Sándor Általános Iskola és Alapfokú Mûvészeti Iskola Telephelye" "Berettyóújfalui TK")
    ("Furtai Bessenyei György Általános Iskola Furta Kossuth utcai telephelye" "Berettyóújfalui TK")
    ("Furtai Bessenyei György Általános Iskola Furta Templom u. 10. sz. alatti telephelye" "Berettyóújfalui TK")
    ("Hajdúszoboszlói Bárdos Lajos Általános Iskola" "Berettyóújfalui TK")
    ("Hosszúpályi Irinyi József Általános Iskola Sinay Miklós Tagiskolája" "Berettyóújfalui TK")
    ("Hosszúpályi Irinyi József Általános Iskola Szabadság tér 12. sz. alatti telephelye" "Berettyóújfalui TK")
    ("Hõgyes Endre Gimnázium Hajdúszoboszló Rákóczi u. 58-64. szám alatti telephelye" "Berettyóújfalui TK")
    ("Irinyi Károly Általános Iskola Csere-erdõ Általános Iskolája" "Berettyóújfalui TK")
    ("Irinyi Károly Általános Iskola Esztár Árpád utcai telephely" "Berettyóújfalui TK")
    ("Irinyi Károly Általános Iskola Fekete Borbála Általános Iskolája" "Berettyóújfalui TK")
    ("Irinyi Károly Általános Iskola Gáborján Fõ utca 83-85.Telephely" "Berettyóújfalui TK")
    ("Jókai Mór Általános Iskola  Kossuth utca 53. sz. alatti Telephely" "Berettyóújfalui TK")
    ("Kálvin Téri Általános Iskola" "Berettyóújfalui TK")
    ("Karacs Ferenc Kollégium" "Berettyóújfalui TK")
    ("Kövy Sándor Általános Iskola és Alapfokú Mûvészeti Iskola Telephelye" "Berettyóújfalui TK")
    ("Létavértesi Arany János Általános Iskola Árpád tér 7. szám alatti telephelye" "Berettyóújfalui TK")
    ("Létavértesi Irinyi János Általános Iskola" "Berettyóújfalui TK")
    ("Létavértesi Irinyi János Általános Iskola - Kassai utca 16. szám alatti telephelye" "Berettyóújfalui TK")
    ("Magyarhomorogi Szabó Pál Általános Iskola" "Berettyóújfalui TK")
    ("Mikepércsi Hunyadi János Általános Iskola" "Berettyóújfalui TK")
    ("Nádudvari Népi Kézmûves Szakgimnázium és Kollégium Ady Endre téri telephelye" "Berettyóújfalui TK")
    ("Nagyhegyesi Veres Péter Általános Iskola" "Berettyóújfalui TK")
    ("Nagyrábéi Móricz Zsigmond Általános Iskola Bihartordai Tagintézménye" "Berettyóújfalui TK")
    ("Nagyrábéi Móricz Zsigmond Általános Iskola Rétszentmiklósi út 2/b. telephelye" "Berettyóújfalui TK")
    ("Petritelepi Általános Iskola" "Berettyóújfalui TK")
    ("Pocsaji Lorántffy Zsuzsanna Általános Iskola" "Berettyóújfalui TK")
    ("Püspökladányi Petõfi Sándor Általános Iskola Bajcsy-Zsilinszky utca 7. szám alatti Telephely" "Berettyóújfalui TK")
    ("Sárándi Kossuth Lajos Általános Iskola" "Berettyóújfalui TK")
    ("Sári Gusztáv Általános Iskola és Alapfokú Mûvészeti Iskola Kaba, Kossuth u. 3. szám alatti telephelye" "Berettyóújfalui TK")
    ("Sári Gusztáv Általános Iskola és Alapfokú Mûvészeti Iskola Zichy Géza Tagiskolája" "Berettyóújfalui TK")
    ("Szerepi Kelemen János Általános Iskola" "Berettyóújfalui TK")
    ("Szûcs Sándor Általános Iskola Rákóczi út 17-19. Telephelye" "Berettyóújfalui TK")
    ("Thököly Imre Két Tanítási Nyelvû Általános Iskola" "Berettyóújfalui TK")
    ("Zichy Géza Alapfokú Mûvészeti Iskola" "Berettyóújfalui TK")
    ("Zichy Géza Alapfokú Mûvészeti Iskola Hajdúszoboszló, Hõforrás Utcai Telephelye" "Berettyóújfalui TK")
    ("Zsákai Kölcsey Ferenc Általános Iskola" "Berettyóújfalui TK")
    ("Abonyi Montágh Imre Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda és Általános Iskola Tószegi úti Telephelye" "Ceglédi TK")
    ("Bihari János Alapfokú Mûvészeti Iskola Báthory István utcai Telephelye" "Ceglédi TK")
    ("Bihari János Alapfokú Mûvészeti Iskola Szelei úti Telephelye" "Ceglédi TK")
    ("Cegléd Erkel Ferenc Alapfokú Mûvészeti Iskola Albertirsai Tagintézmény Köztársaság utcai Telephelye" "Ceglédi TK")
    ("Ceglédberceli Eötvös József Nyelvoktató Nemzetiségi Általános Iskola és Alapfokú Mûvészeti Iskola" "Ceglédi TK")
    ("Ceglédi Erkel Ferenc Alapfokú Mûvészeti Iskola" "Ceglédi TK")
    ("Ceglédi Erkel Ferenc Alapfokú Mûvészeti Iskola Eötvös téri Telephelye" "Ceglédi TK")
    ("Ceglédi Erkel Ferenc Alapfokú Mûvészeti Iskola Szabadság téri Telephelye" "Ceglédi TK")
    ("Ceglédi Kossuth Lajos Gimnázium" "Ceglédi TK")
    ("Ceglédi Táncsics Mihály Általános Iskola" "Ceglédi TK")
    ("Ceglédi Táncsics Mihály Általános Iskola Népkör utcai telephelye" "Ceglédi TK")
    ("Csemõi Ladányi Mihály Általános Iskola" "Ceglédi TK")
    ("Damjanich János Gimnázium és Mezõgazdasági Technikum" "Ceglédi TK")
    ("Damjanich János Gimnázium és Mezõgazdasági Technikum Dózsa György út 26/A. hrsz. 2211. hrsz. Telephelye" "Ceglédi TK")
    ("Damjanich János Gimnázium és Mezõgazdasági Technikum külterület 0620/8. hrsz. Telephelye" "Ceglédi TK")
    ("Dánszentmiklósi Ady Endre Általános Iskola és Alapfokú Mûvészeti Iskola" "Ceglédi TK")
    ("Dózsa György Kollégium Nagykõrösi Tagintézménye" "Ceglédi TK")
    ("Gyulai Gaál Miklós Általános Iskola és Alapfokú Mûvészeti Iskola Kálvin János utca 9. szám alatti Telephelye" "Ceglédi TK")
    ("Gyulai Gaál Miklós Általános Iskola és Alapfokú Mûvészeti Iskola Szolnoki úti Telephelye" "Ceglédi TK")
    ("Jászkarajenõi Széchenyi István Általános Iskola" "Ceglédi TK")
    ("Kazinczy Ferenc Általános Iskola és Alapfokú Mûvészeti Iskola Telephelye" "Ceglédi TK")
    ("Losontzi Egységes Gyógypedagógiai Módszertani Intézmény Ceglédberceli Telephelye" "Ceglédi TK")
    ("Losontzi István Egységes Gyógypedagógiai Módszertani Intézmény, Szakiskola, Készségfejlesztõ Iskola és Kollégium Ceglédi Telephely" "Ceglédi TK")
    ("Matolcsy Miklós Általános Iskola Zrínyi utcai Telephelye" "Ceglédi TK")
    ("Mátray Gábor Általános Iskola Görgey utcai Telephelye" "Ceglédi TK")
    ("Mendei Géza Fejedelem Általános Iskola" "Ceglédi TK")
    ("Nagykátai Járási Óvoda, Általános Iskola, Egységes Gyógypedagógiai Módszertani Intézmény" "Ceglédi TK")
    ("Nagykátai Liszt Ferenc Alapfokú Mûvészeti Iskola" "Ceglédi TK")
    ("Nagykátai Liszt Ferenc Alapfokú Mûvészeti Iskola Kókai Telephelye" "Ceglédi TK")
    ("Nagykátai Liszt Ferenc Alapfokú Mûvészeti Iskola Tápiószelei Telephelye" "Ceglédi TK")
    ("Nagykátai Liszt Ferenc Alapfokú Mûvészeti Iskola Tápiószentmártoni Tagintézménye Farmosi Telephely" 	"Ceglédi TK")
    ("Nagykõrösi II. Rákóczi Ferenc Általános Iskola" "Ceglédi TK")
    ("Nagykõrösi II. Rákóczi Ferenc Általános Iskola Kálvin téri Telephelye" "Ceglédi TK")
    ("Nagykõrösi Kossuth Lajos Általános Iskola" "Ceglédi TK")
    ("Nagykõrösi Petõfi Sándor Általános Iskola" "Ceglédi TK")
    ("Pest Vármegyei Pedagógiai Szakszolgálat" "Ceglédi TK")
    ("Pest Vármegyei Pedagógiai Szakszolgálat Aszódi Tagintézménye" "Ceglédi TK")
    ("Pest Vármegyei Pedagógiai Szakszolgálat Budakeszi Tagintézménye" "Ceglédi TK")
    ("Pest Vármegyei Pedagógiai Szakszolgálat Budapesti Városligeti fasori Tagintézménye" "Ceglédi TK")
    ("Pest Vármegyei Pedagógiai Szakszolgálat Ceglédi Tagintézménye" "Ceglédi TK")
    ("Pest Vármegyei Pedagógiai Szakszolgálat Dunakeszi Tagintézmény Fóti Telephelye" "Ceglédi TK")
    ("Pest Vármegyei Pedagógiai Szakszolgálat Dunakeszi Tagintézménye" "Ceglédi TK")
    ("Pest Vármegyei Pedagógiai Szakszolgálat Érdi Tagintézmény Százhalombattai Telephelye" "Ceglédi TK")
    ("Pest Vármegyei Pedagógiai Szakszolgálat Érdi Tagintézmény Törökbálinti Telephelye" "Ceglédi TK")
    ("Pest Vármegyei Pedagógiai Szakszolgálat Érdi Tagintézményének Százhalombattai 2. Telephelye" "Ceglédi TK")
    ("Pest Vármegyei Pedagógiai Szakszolgálat Gödöllõi Tagintézmény Kistarcsai Telephelye" "Ceglédi TK")
    ("Pest Vármegyei Pedagógiai Szakszolgálat Gödöllõi Tagintézmény Veresegyházi Telephelye" "Ceglédi TK")
    ("Pest Vármegyei Pedagógiai Szakszolgálat Gyáli Tagintézménye" "Ceglédi TK")
    ("Pest Vármegyei Pedagógiai Szakszolgálat Monori Tagintézménye" "Ceglédi TK")
    ("Pest Vármegyei Pedagógiai Szakszolgálat Nagykõrösi Tagintézménye" "Ceglédi TK")
    ("Pest Vármegyei Pedagógiai Szakszolgálat Ráckevei Tagintézmény Kiskunlacházai Telephelye" "Ceglédi TK")
    ("Pest Vármegyei Pedagógiai Szakszolgálat Szentendrei Tagintézmény Budakalászi Telephelye" "Ceglédi TK")
    ("Pest Vármegyei Pedagógiai Szakszolgálat Szigetszentmiklósi Tagintézmény Dunaharaszti Telephelye" "Ceglédi TK")
    ("Pest Vármegyei Pedagógiai Szakszolgálat Szigetszentmiklósi Tagintézménye" "Ceglédi TK")
    ("Pest Vármegyei Pedagógiai Szakszolgálat Szigetszentmiklósi Telephelye 2" 	"Ceglédi TK")
    ("Pest Vármegyei Pedagógiai Szakszolgálat Üllõi Tagintézménye" "Ceglédi TK")
    ("Sülysápi Móra Ferenc Általános Iskola" "Ceglédi TK")
    ("Sülysápi Szent István Általános Iskola" "Ceglédi TK")
    ("Tápióbicskei Földváry Károly Általános Iskola" "Ceglédi TK")
    ("Tápiószecsõi Széchenyi István Általános Iskola és Alapfokú Mûvészeti Iskola" "Ceglédi TK")
    ("Tápiószelei Blaskovich János Általános Iskola" "Ceglédi TK")
    ("Tápiószentmártoni Kubinyi Ágoston Általános Iskola" "Ceglédi TK")
    ("Tessedik Sámuel Általános Iskola" "Ceglédi TK")
    ("Tóalmási Kõrösi Csoma Sándor Általános Iskola" "Ceglédi TK")
    ("Törteli Szent István Király Általános Iskola Telephelye" "Ceglédi TK")
    ("Úri Szent Imre Általános Iskola és Alapfokú Mûvészeti Iskola Telephelye" "Ceglédi TK")
    ("Várkonyi István Általános Iskola Rákóczi úti Telephelye" "Ceglédi TK")
    ("Weiner Leó Zeneiskola Alapfokú Mûvészeti Iskola Kocséri Telephelye" "Ceglédi TK")
    ("Weiner Leó Zeneiskola Alapfokú Mûvészeti Iskola Nagykõrös, Kecskeméti utcai Telephelye" "Ceglédi TK")
    ("Weiner Leó Zeneiskola Alapfokú Mûvészeti Iskola Nagykõrös, Losonczy utcai Telephelye" "Ceglédi TK")
    ("Weiner Leó Zeneiskola Alapfokú Mûvészeti Iskola Nagykõrös, Vadas utcai Telephelye" "Ceglédi TK")
    ("Ábrányi Emil Általános Iskola" "Debreceni TK")
    ("Bagaméri Általános Iskola és Alapfokú Mûvészeti Iskola" "Debreceni TK")
    ("Bagaméri Általános Iskola és AMI Bagamér, Kossuth utca 3. szám alatti telephelye" "Debreceni TK")
    ("Bagaméri Általános Iskola és AMI Bagamér, Rákóczi utca 2. szám alatti telephelye" "Debreceni TK")
    ("Bagaméri Általános Iskola és AMI Nyíradony Iskola úti telephelye" "Debreceni TK")
    ("Bagaméri Általános Iskola és AMI Újléta telephelye" "Debreceni TK")
    ("Csapókerti Általános Iskola Hajdúsámsoni Tagintézménye" "Debreceni TK")
    ("Debreceni Árpád Vezér Általános Iskola" "Debreceni TK")
    ("Debreceni Bárczi Gusztáv Egységes Gyógypedagógiai Módszertani Intézmény, Általános Iskola, Készségfejlesztõ Iskola és Kollégium Nagy Gál István utcai telephelye" "Debreceni TK")
    ("Debreceni Benedek Elek Általános Iskola" "Debreceni TK")
    ("Debreceni Bolyai János Általános Iskola és Alapfokú Mûvészeti Iskola" "Debreceni TK")
    ("Debreceni Deák Ferenc Tehetségfejlesztõ Középiskolai Szakkollégium" "Debreceni TK")
    ("Debreceni Fazekas Mihály Általános Iskola" "Debreceni TK")
    ("Debreceni Gönczy Pál Általános Iskola" "Debreceni TK")
    ("Debreceni Gönczy Pál Általános Iskola Rózsavölgy utca 32-34. sz. Telephelye" "Debreceni TK")
    ("Debreceni Hunyadi János Általános Iskola" 	"Debreceni TK")
    ("Debreceni Kazinczy Ferenc Általános Iskola és Alapfokú Mûvészeti Iskola" "Debreceni TK")
    ("Debreceni Kinizsi Pál Általános Iskola Monostorpályi Úti Tagintézménye" "Debreceni TK")
    ("Debreceni Lorántffy Zsuzsanna Általános Iskola Telephelye" "Debreceni TK")
    ("Debreceni Petõfi Sándor Általános Iskola és Alapfokú Mûvészeti Iskola Szabó Kálmán utca 13.szám alatti telephelye" "Debreceni TK")
    ("Epreskerti Általános Iskola" "Debreceni TK")
    ("Hajdú-Bihar Vármegyei Általános Iskola, Gimnázium, Szakgimnázium, Technikum és Kollégium" "Debreceni TK")
    ("Hajdú-Bihar Vármegyei Pedagógiai Szakszolgálat Balmazújvárosi Tagintézménye" "Debreceni TK")
    ("Hajdú-Bihar Vármegyei Pedagógiai Szakszolgálat Berettyóújfalui Tagintézménye" "Debreceni TK")
    ("Hajdú-Bihar Vármegyei Pedagógiai Szakszolgálat Debreceni Tagintézménye" "Debreceni TK")
    ("Hajdú-Bihar Vármegyei Pedagógiai Szakszolgálat Debreceni Tagintézménye Jerikó Utcai Telephelye" "Debreceni TK")
    ("Hajdú-Bihar Vármegyei Pedagógiai Szakszolgálat Hajdúböszörményi Tagintézménye" "Debreceni TK")
    ("Hajdú-Bihar Vármegyei Pedagógiai Szakszolgálat Hajdúhadházi Tagintézménye" "Debreceni TK")
    ("Hajdú-Bihar Vármegyei Pedagógiai Szakszolgálat Hajdúszoboszlói Tagintézménye" "Debreceni TK")
    ("Hajdú-Bihar Vármegyei Pedagógiai Szakszolgálat Nyíradonyi Tagintézménye" "Debreceni TK")
    ("Hallássérültek Egységes Gyógypedagógiai Módszertani Intézménye, Óvoda, Általános Iskola és Kollégium" "Debreceni TK")
    ("Kiss Zoltán Általános Iskola" "Debreceni TK")
    ("Kodály Zoltán Zenemûvészeti Szakgimnázium és Zeneiskola-Alapfokú Mûvészeti Iskola" "Debreceni TK")
    ("Kodály Zoltán Zenemûvészeti Szakgimnázium és Zeneiskola-Alapfokú Mûvészeti Iskola Gönczy Pál Utcai Telephelye" "Debreceni TK")
    ("Kodály Zoltán Zenemûvészeti Szakgimnázium és Zeneiskola-Alapfokú Mûvészeti Iskola Hunyadi János Utcai Telephelye" "Debreceni TK")
    ("Kodály Zoltán Zenemûvészeti Szakgimnázium és Zeneiskola-Alapfokú Mûvészeti Iskola Kossuth Utcai Telephelye" "Debreceni TK")
    ("Kodály Zoltán Zenemûvészeti Szakgimnázium és Zeneiskola-Alapfokú Mûvészeti Iskola Péterfia Utcai Telephelye" "Debreceni TK")
    ("Lilla Téri Általános Iskola" "Debreceni TK")
    ("Lilla Téri Általános Iskola Lilla téri telephelye" "Debreceni TK")
    ("Medgyessy Ferenc Gimnázium, Mûvészeti Szakgimnázium és Technikum 002-es telephelye - Holló László Emlékmúzeum és Kerámia Mûhely" "Debreceni TK")
    ("Medgyessy Ferenc Gimnázium, Mûvészeti Szakgimnázium és Technikum 004-es telephelye - Festõ- és Fotó Mûhely" "Debreceni TK")
    ("Medgyessy Ferenc Gimnázium, Mûvészeti Szakgimnázium és Technikum 006-os telephelye - Táncterem és mûvészeti szaktanterem" "Debreceni TK")
    ("Nyírmártonfalvai Általános Iskola" "Debreceni TK")
    ("Tóth Árpád Gimnázium" "Debreceni TK")
    ("Árpád Utcai Német Nemzetiségi Nyelvoktató Általános Iskola" "Dél-Budai TK")
    ("Bethlen Gábor Általános Iskola és Gimnázium Kincskeresõ Tagiskolája" "Dél-Budai TK")
    ("Budafok - Tétényi Baross Gábor Általános Iskola" "Dél-Budai TK")
    ("Budafok - Tétényi Nádasdy Kálmán Alapfokú Mûvészeti Iskola és Általános Iskola Árpád Utca 2. Telephelye" "Dél-Budai TK")
    ("Budafok - Tétényi Nádasdy Kálmán Alapfokú Mûvészeti Iskola és Általános Iskola Dózsa György út 84-94. Telephelye" "Dél-Budai TK")
    ("Budafok - Tétényi Nádasdy Kálmán Alapfokú Mûvészeti Iskola és Általános Iskola Kossuth Lajos utca 22. Telephelye" "Dél-Budai TK")
    ("Budafok - Tétényi Nádasdy Kálmán Alapfokú Mûvészeti Iskola és Általános Iskola Rákóczi út 26. Telephelye" "Dél-Budai TK")
    ("Budafok - Tétényi Nádasdy Kálmán Alapfokú Mûvészeti Iskola és Általános Iskola Tompa utca 2-4. Telephelye" "Dél-Budai TK")
    ("Budafoki Herman Ottó Általános Iskola Telephelye" "Dél-Budai TK")
    ("Budafok-Tétényi Nádasdy Kálmán Alapfokú Mûvészeti Iskola és Általános Iskola Anna utca 13-15. Telephely" "Dél-Budai TK")
    ("Budapest XXII. Kerületi Bartók Béla Magyar - Angol Két Tanítási Nyelvû Általános Iskola" "Dél-Budai TK")
    ("Budatétényi Kozmutza Flóra Óvoda, Általános Iskola, Szakiskola, Egységes Gyógypedagógiai Módszertani Intézmény" "Dél-Budai TK")
    ("Farkasréti Általános Iskola" "Dél-Budai TK")
    ("Gazdagrét - Törökugrató Általános Iskola" "Dél-Budai TK")
    ("Hugonnai Vilma Általános Iskola" "Dél-Budai TK")
    ("Kempelen Farkas Gimnázium" "Dél-Budai TK")
    ("Lágymányosi Bárdos Lajos Két Tanítási Nyelvû Általános Iskola" "Dél-Budai TK")
    ("Õrmezei Általános Iskola" "Dél-Budai TK")
    ("Újbudai Ádám Jenõ Általános Iskola" "Dél-Budai TK")
    ("Újbudai Gárdonyi Géza Általános Iskola" "Dél-Budai TK")
    ("Újbudai Montágh Imre Általános Iskola, Óvoda, Fejlesztõ Nevelés-oktatást Végzõ Iskola, Készségfejlesztõ Iskola, Egységes Gyógypedagógiai Módszertani Intézmény" "Dél-Budai TK")
    ("Újbudai Montágh Imre Általános Iskola, Óvoda, Fejlesztõ Nevelés-oktatást Végzõ Iskola, Készségfejlesztõ Iskola, Egységes Gyógypedagógiai Módszertani Intézmény Rátz László utcai Telephelye" "Dél-Budai TK")
    ("Újbudai Széchenyi István Gimnázium" "Dél-Budai TK")
    ("Bakáts Téri Ének-zenei Általános Iskola" "Dél-Pesti TK")
    ("Budapest IX. Kerületi József Attila Általános Iskola és Alapfokú Mûvészeti Iskola Bakáts Téri Telephelye" "Dél-Pesti TK")
    ("Budapest IX. Kerületi Kosztolányi Dezsõ Általános Iskola" "Dél-Pesti TK")
    ("Budapest IX. Kerületi Leövey Klára Gimnázium" "Dél-Pesti TK")
    ("Budapest IX. Kerületi Molnár Ferenc Magyar-Angol Két Tanítási Nyelvû Általános Iskola" "Dél-Pesti TK")
    ("Budapest IX. Kerületi Szent-Györgyi Albert Általános Iskola és Gimnázium" "Dél-Pesti TK")
    ("Budapest IX. Kerületi Weöres Sándor Általános Iskola és Gimnázium Lobogó utcai Telephelye (Uszoda)" "Dél-Pesti TK")
    ("Budapest IX. Kerületi Weöres Sándor Általános Iskola és Gimnázium Tagintézmény Toronyház utcai Telephelye (Jégcsarnok" "Dél-Pesti TK")
    ("Budapest XXI. Kerületi Arany János Általános Iskola" "Dél-Pesti TK")
    ("Budapest XXI. Kerületi Herman Ottó Általános Iskola" "Dél-Pesti TK")
    ("Budapest XXI. Kerületi Katona József Általános Iskola" "Dél-Pesti TK")
    ("Budapest XXI. Kerületi Kölcsey Ferenc Általános Iskola" "Dél-Pesti TK")
    ("Budapest XXI. Kerületi Móra Ferenc Általános Iskola" "Dél-Pesti TK")
    ("Budapest XXI. Kerületi Széchenyi István Általános és Kéttannyelvû Általános Iskola" "Dél-Pesti TK")
    ("Budapest XXIII. Kerületi Fekete István Általános Iskola" "Dél-Pesti TK")
    ("Budapest XXIII. Kerületi Galambos János Zenei Alapfokú Mûvészeti Iskola 002-es Telephely" "Dél-Pesti TK")
    ("Budapest XXIII. Kerületi Galambos János Zenei Alapfokú Mûvészeti Iskola 004-es Telephely" "Dél-Pesti TK")
    ("Budapest XXIII. Kerületi Galambos János Zenei Alapfokú Mûvészeti Iskola 008-as Telephely" "Dél-Pesti TK")
    ("Budapest XXIII. Kerületi Grassalkovich Antal Általános Iskola" "Dél-Pesti TK")
    ("Budapest XXIII. Kerületi Páneurópa Általános Iskola" "Dél-Pesti TK")
    ("Budapesti IX. Kerületi József Attila Általános Iskola és Alapfokú Mûvészeti Iskola Ifjúmunkás utcai Telephelye" "Dél-Pesti TK")
    ("Csepeli Fasang Árpád Alapfokú Mûvészeti Iskola Árpád Utcai Telephelye" "Dél-Pesti TK")
    ("Csepeli Fasang Árpád Alapfokú Mûvészeti Iskola Dr. Koncz János téri telephelye" "Dél-Pesti TK")
    ("Csepeli Fasang Árpád Alapfokú Mûvészeti Iskola Iskola tér telephelye" "Dél-Pesti TK")
    ("Csepeli Fasang Árpád Alapfokú Mûvészeti Iskola Kolozsvári utca telephelye" "Dél-Pesti TK")
    ("Csepeli Fasang Árpád Alapfokú Mûvészeti Iskola Szárcsa utca telephelye" "Dél-Pesti TK")
    ("Csepeli Fasang Árpád Alapfokú Mûvészeti Iskola Széchenyi utca telephelye" "Dél-Pesti TK")
    ("Csepeli Fasang Árpád Alapfokú Mûvészeti Iskola Szent László utca telephelye" "Dél-Pesti TK")
    ("Csepeli Fasang Árpád Alapfokú Mûvészeti Iskola SZÍN-PAD-KÉP Tagintézményének Nyír utcai telephelye" "Dél-Pesti TK")
    ("Csepeli Fasang Árpád Alapfokú Mûvészeti Iskola SZÍN-PAD-KÉP Tagintézményének Táncsics Mihály utcai telephelye" "Dél-Pesti TK")
    ("Csepeli Fasang Árpád Alapfokú Mûvészeti Iskola Tejút utca telephelye" "Dél-Pesti TK")
    ("Dió Általános Iskola, Készségfejlesztõ Iskola, Egységes Gyógypedagógiai Módszertani Intézmény és Kollégium" "Dél-Pesti TK")
    ("Ferencvárosi Ádám Jenõ Zeneiskola - Alapfokú Mûvészeti Iskola Ifjúmunkás utca 1. alatti telephelye" "Dél-Pesti TK")
    ("Ferencvárosi Ádám Jenõ Zeneiskola - Alapfokú Mûvészeti Iskola Lobogó utcai telephelye" "Dél-Pesti TK")
    ("Ferencvárosi Ádám Jenõ Zeneiskola - Alapfokú Mûvészeti Iskola Mester utca 19. alatti telephelye" "Dél-Pesti TK")
    ("Ferencvárosi Ádám Jenõ Zeneiskola-Alapfokú Mûvészeti Iskola" "Dél-Pesti TK")
    ("Ferencvárosi EGYMI Vágóhíd Utcai Óvoda Tagozata" "Dél-Pesti TK")
    ("Ferencvárosi Sport Általános Iskola és Gimnázium" "Dél-Pesti TK")
    ("Jedlik Ányos Gimnázium" "Dél-Pesti TK")
    ("Mészáros Jenõ Óvoda, Általános Iskola és Egységes Gyógypedagógiai Módszertani Intézmény Kiss János altábornagy utcai telephelye" "Dél-Pesti TK")
    ("Szárcsa Általános Iskola" "Dél-Pesti TK")
    ("Bajza Lenke Általános Iskola" "Dunakeszi TK")
    ("Csengey Gusztáv Általános Iskola Rákóczi Ferenc utcai Telephely" "Dunakeszi TK")
    ("Csömöri Krammer Teréz Zenei Alapfokú Mûvészeti Iskola Major úti Telephelye" "Dunakeszi TK")
    ("Csömöri Mátyás Király Általános Iskola Szabadság Úti Telephelye" "Dunakeszi TK")
    ("Dányi Alapfokú Mûvészeti Iskola Zsámboki Telephely" "Dunakeszi TK")
    ("Dányi Széchenyi István Általános Iskola Pesti úti Telephelye" "Dunakeszi TK")
    ("Dunakeszi Bárdos Lajos Általános Iskola 004-es telephelye" "Dunakeszi TK")
    ("Dunakeszi Farkas Ferenc Alapfokú Mûvészeti Iskola Bazsanth Vince úti Telephelye" "Dunakeszi TK")
    ("Dunakeszi Farkas Ferenc Alapfokú Mûvészeti Iskola Garas utcai Telephelye" "Dunakeszi TK")
    ("Dunakeszi Farkas Ferenc Alapfokú Mûvészeti Iskola Károlyi utcai Telephelye" "Dunakeszi TK")
    ("Dunakeszi Farkas Ferenc Alapfokú Mûvészeti Iskola Radnóti utcai Telephelye" "Dunakeszi TK")
    ("Dunakeszi Farkas Ferenc Alapfokú Mûvészeti Iskola Táncsics utcai Telephelye" "Dunakeszi TK")
    ("Dunakeszi IV. Béla Király Gimnázium" "Dunakeszi TK")
    ("Dunakeszi Radnóti Miklós Gimnázium" "Dunakeszi TK")
    ("Dunakeszi Széchenyi István Általános Iskola Posta utcai telephely" "Dunakeszi TK")
    ("Erdõkertesi Neumann János Általános Iskola" "Dunakeszi TK")
    ("Fabriczius József Általános Iskola" "Dunakeszi TK")
    ("Fóti Fáy András Általános Iskola" "Dunakeszi TK")
    ("Fóti Liszt Ferenc Alapfokú Mûvészeti Iskola" "Dunakeszi TK")
    ("Fóti Liszt Ferenc Alapfokú Mûvészeti Iskola Béke úti telephelye" "Dunakeszi TK")
    ("Fóti Liszt Ferenc Alapfokú Mûvészeti Iskola Fáy András téri Telephelye" "Dunakeszi TK")
    ("Fóti Liszt Ferenc Alapfokú Mûvészeti Iskola Szent László utca 1. alatti telephelye" "Dunakeszi TK")
    ("Fóti Liszt Ferenc Alapfokú Mûvészeti Iskola Vörösmarty tér 3. alatti telephelye" "Dunakeszi TK")
    ("Fóti Liszt Ferenc Mûvészeti Iskola Károlyi István utca 44. alatti Telephelye" "Dunakeszi TK")
    ("Fóti Zeneiskola - Alapfokú Mûvészeti Iskola Vörösmarty tér 4. alatti Telephelye" "Dunakeszi TK")
    ("Galgahévízi II. Rákóczi Ferenc Általános Iskola" "Dunakeszi TK")
    ("Gödi Németh László Általános Iskola és Alapfokú Mûvészeti Iskola" "Dunakeszi TK")
    ("Gödi Németh László Általános Iskola és Alapfokú Mûvészeti Iskola Kálmán Utcai Telephelye" "Dunakeszi TK")
    ("Gödi Németh László Általános Iskola és Alapfokú Mûvészeti Iskola Petõfi Sándor Utcai Telephelye" "Dunakeszi TK")
    ("Gödöllõi Erkel Ferenc Általános Iskola" "Dunakeszi TK")
    ("Gödöllõi Hajós Alfréd Általános Iskola" "Dunakeszi TK")
    ("Gödöllõi Montágh Imre Általános Iskola, Szakiskola és Készségfejlesztõ Iskola" "Dunakeszi TK")
    ("Gödöllõi Török Ignác Gimnázium" "Dunakeszi TK")
    ("Hévízgyörki Petõfi Sándor Általános Iskola Telephelye" "Dunakeszi TK")
    ("Huzella Tivadar Két Tanítási Nyelvû Általános Iskola 001-es Telephelye" "Dunakeszi TK")
    ("Isaszegi Damjanich János Általános Iskola" "Dunakeszi TK")
    ("Kartali Könyves Kálmán Általános Iskola Telephelye" "Dunakeszi TK")
    ("Kerepesi Széchenyi István Általános Iskola" 	"Dunakeszi TK")
    ("Klapka György Általános Iskola és Alapfokú Mûvészeti Iskola Dózsa György úti Telephelye" "Dunakeszi TK")
    ("Klapka György Általános Iskola és Alapfokú Mûvészeti Iskola Tóth Árpád utcai Telephelye" "Dunakeszi TK")
    ("Lisznyay Szabó Gábor Alapfokú Mûvészet Iskola Veresegyház, Köves út 14. szám alatti telephelye" "Dunakeszi TK")
    ("Lisznyay Szabó Gábor Alapfokú Mûvészeti Iskola" "Dunakeszi TK")
    ("Lisznyay Szabó Gábor Alapfokú Mûvészeti Iskola Mogyoródi Telephelye" "Dunakeszi TK")
    ("Lisznyay Szabó Gábor Alapfokú Mûvészeti Iskola Veresegyház, Fõ út 77-79. szám alatti telephelye" "Dunakeszi TK")
    ("Mogyoródi Szent László Általános Iskola" "Dunakeszi TK")
    ("Nagytarcsai Blaskovits Oszkár Általános Iskola" "Dunakeszi TK")
    ("Péceli Alapfokú Mûvészeti Iskola" "Dunakeszi TK")
    ("Péceli Alapfokú Mûvészeti Iskola Kossuth tér 7. szám alatti Telephelye" "Dunakeszi TK")
    ("Péceli Integrált Oktatási Központ Általános Iskola és Gimnázium" "Dunakeszi TK")
    ("Podmaniczky Alapfokú Mûvészeti Iskola" "Dunakeszi TK")
    ("Podmaniczky Alapfokú Mûvészeti Iskola Aszód, Rákóczi úti Telephelye" "Dunakeszi TK")
    ("Podmaniczky Alapfokú Mûvészeti Iskola Domonyi Telephelye" "Dunakeszi TK")
    ("Podmaniczky Alapfokú Mûvészeti Iskola Galgagyörki Telephelye" "Dunakeszi TK")
    ("Podmaniczky Alapfokú Mûvészeti Iskola Galgamácsai Telephelye" "Dunakeszi TK")
    ("Podmaniczky Alapfokú Mûvészeti Iskola Ikladi Telephelye" "Dunakeszi TK")
    ("Podmaniczky Alapfokú Mûvészeti Iskola Püspökhatvani Telephelye" "Dunakeszi TK")
    ("Simándy József Általános Iskola és Alapfokú Mûvészeti Iskola" "Dunakeszi TK")
    ("Szadai Székely Bertalan Általános Iskola" "Dunakeszi TK")
    ("Turai Hevesy György Általános Iskola" "Dunakeszi TK")
    ("Turai Hevesy György Általános Iskola Park úti Telephelye" "Dunakeszi TK")
    ("Turai Hevesy György Általános Iskola Tabán út 44. Telephelye" "Dunakeszi TK")
    ("Valkói Móra Ferenc Általános Iskola" "Dunakeszi TK")
    ("Veresegyházi Egységes Gyógypedagógiai Módszertani Intézmény, Általános Iskola és Óvoda - Dunakeszi ÉRTAK Iskolai Telephelye" 	"Dunakeszi TK")
    ("Veresegyházi Egységes Gyógypedagógiai Módszertani Intézmény, Általános Iskola és Óvoda - Dunakeszi Óvodai Telephelye" "Dunakeszi TK")
    ("Adonyi Szent István Általános Iskola és Alapfokú Mûvészeti Iskola" "Dunaújvárosi TK")
    ("Besnyõi Arany János Általános Iskola" 	"Dunaújvárosi TK")
    ("Cecei Illyés Gyula Általános Iskola Arany László Tagiskolája" "Dunaújvárosi TK")
    ("Dunaújvárosi Arany János Általános Iskola" "Dunaújvárosi TK")
    ("Dunaújvárosi Móricz Zsigmond Általános Iskola" "Dunaújvárosi TK")
    ("Dunaújvárosi Rosti Pál Gimnázium és Általános Iskola" "Dunaújvárosi TK")
    ("Dunaújvárosi Sándor Frigyes Alapfokú Mûvészeti Iskola Kulcsi Telephelye" "Dunaújvárosi TK")
    ("Dunaújvárosi Széchenyi István Gimnázium" "Dunaújvárosi TK")
    ("Dunaújvárosi Vasvári Pál Általános Iskola Kisapostagi Telephelye" "Dunaújvárosi TK")
    ("Ercsi Eötvös József Általános Iskola" "Dunaújvárosi TK")
    ("Kossuth Zsuzsanna Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelés-Oktatást Végzõ Iskola, Egységes Gyógypedagógiai Módszertani Intézmény" "Dunaújvárosi TK")
    ("Martonvásári Alapfokú Mûvészeti Iskola" "Dunaújvárosi TK")
    ("Martonvásári Alapfokú Mûvészeti Iskola Ercsi Telephelye" "Dunaújvárosi TK")
    ("Martonvásári Alapfokú Mûvészeti Iskola Váli Telephelye" "Dunaújvárosi TK")
    ("Martonvásári Beethoven Általános Iskola Kajászói Telephelye" "Dunaújvárosi TK")
    ("Mezõfalvi Petõfi Sándor Általános Iskola és Alapfokú Mûvészeti Iskola" "Dunaújvárosi TK")
    ("Mezõfalvi Petõfi Sándor Általános Iskola és Alapfokú Mûvészeti Iskola Benedek Elek Tagiskolájának Daru Sori Telephelye" "Dunaújvárosi TK")
    ("Móra Ferenc Általános Iskola, Fejlesztõ Nevelés-Oktatást Végzõ Iskola, Egységes Gyógypedagógiai Módszertani Intézmény" "Dunaújvárosi TK")
    ("Pápay Ágoston Általános Iskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelés-Oktatást Végzõ Iskola és Kollégium" "Dunaújvárosi TK")
    ("Pusztaszabolcsi József Attila Általános Iskola" "Dunaújvárosi TK")
    ("Ráckeresztúri Petõfi Sándor Általános Iskola" "Dunaújvárosi TK")
    ("Sárbogárdi Mészöly Géza Általános Iskola Szent István Tagiskolája" "Dunaújvárosi TK")
    ("Sárbogárdi Petõfi Sándor Gimnázium" "Dunaújvárosi TK")
    ("Sárkeresztúri Általános Iskola" "Dunaújvárosi TK")
    ("Sárszentmiklósi Általános Iskola" "Dunaújvárosi TK")
    ("Sárszentmiklósi Általános Iskola Telephelye" "Dunaújvárosi TK")
    ("Váli Vajda János Általános Iskola" "Dunaújvárosi TK")
    ("Bélapátfalvai Petõfi Sándor Általános Iskola" "Egri TK")
    ("Besenyõtelki Dr. Berze Nagy János Általános Iskola" "Egri TK")
    ("Egercsehi Zrínyi Ilona Általános Iskola" "Egri TK")
    ("Egri Balassi Bálint Általános Iskola" "Egri TK")
    ("Egri Balassi Bálint Általános Iskola Móra Ferenc Tagiskolája" "Egri TK")
    ("Egri Dobó István Gimnázium" "Egri TK")
    ("Egri Hunyadi Mátyás Általános Iskola" "Egri TK")
    ("Egri Kemény Ferenc Sportiskolai Általános Iskola Árpád Fejedelem Tagiskolája" "Egri TK")
    ("Egri Lenkey János Általános Iskola" 	"Egri TK")
    ("Egri Pásztorvölgyi Általános Iskola és Gimnázium" "Egri TK")
    ("Egri Szalaparti Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelés-oktatást Végzõ Iskola és Kollégium Bem Tábornok Utcai Telephelye" "Egri TK")
    ("Egri Szilágyi Erzsébet Gimnázium és Kollégium" "Egri TK")
    ("Erdõteleki Mikszáth Kálmán Általános Iskola Tarnazsadányi Tagiskolája" "Egri TK")
    ("Felsõtárkányi Általános Iskola és Alapfokú Mûvészeti Iskola Telephelye" "Egri TK")
    ("Fleischmann Rudolf Általános Iskola Nagyúti Telephelye" "Egri TK")
    ("Füzesabonyi Teleki Blanka Általános Iskola és Alapfokú Mûvészeti Iskola Telephelye" "Egri TK")
    ("Hanyi-menti Általános Iskola" "Egri TK")
    ("Heves Vármegyei Pedagógiai Szakszolgálat Bélapátfalvai Tagintézménye" "Egri TK")
    ("Heves Vármegyei Pedagógiai Szakszolgálat Egri Tagintézménye Arany János utca 20/A alatti Telephelye" "Egri TK")
    ("Heves Vármegyei Pedagógiai Szakszolgálat Egri Tagintézménye I. számú lakótelep 9. sz. alatti Telephelye" "Egri TK")
    ("Heves Vármegyei Pedagógiai Szakszolgálat Egri Tagintézménye Kallómalom utca 1-3.sz alatti Telephelye" "Egri TK")
    ("Heves Vármegyei Pedagógiai Szakszolgálat Egri Tagintézménye Malomárok utca 1. szám alatti Telephelye" "Egri TK")
    ("Heves Vármegyei Pedagógiai Szakszolgálat Füzesabonyi Tagintézménye" "Egri TK")
    ("Heves Vármegyei Pedagógiai Szakszolgálat Gyöngyösi Tagintézménye Dobó István utca 2. sz. alatti Telephelye" "Egri TK")
    ("Heves Vármegyei Pedagógiai Szakszolgálat Gyöngyösi Tagintézménye Visonta utca 2. sz. alatti Telephelye" "Egri TK")
    ("Heves Vármegyei Pedagógiai Szakszolgálat Hatvani Tagintézménye Bajcsy-Zsilinszky út 8. szám alatti Telephelye" "Egri TK")
    ("Heves Vármegyei Pedagógiai Szakszolgálat Hevesi Tagintézménye" "Egri TK")
    ("Hevesi Körzeti Általános Iskola és Alapfokú Mûvészeti Iskola" "Egri TK")
    ("Hevesi Körzeti Általános Iskola és Alapfokú Mûvészeti Iskola Hevesi József Tagiskolája Telephelye" "Egri TK")
    ("Hevesi Körzeti Általános Iskola és Alapfokú Mûvészeti Iskola Zenemûvészeti Tagintézménye Tarnaméra Telephelye" "Egri TK")
    ("Kápolnai Tarnavölgye Általános Iskola" "Egri TK")
    ("Kápolnai Tarnavölgye Általános Iskola Feldebrõi Telephelye" "Egri TK")
    ("Kiskörei Vásárhelyi Pál Általános Iskola" "Egri TK")
    ("Mezõtárkányi Általános Iskola Egerfarmosi Telephelye" "Egri TK")
    ("Nagy Zoltán Általános Iskola" "Egri TK")
    ("Noszvaji Figedy János Általános Iskola és Alapfokú Mûvészeti Iskola" "Egri TK")
    ("Poroszlói Vass Lajos Általános Iskola Sarudi Telephelye" "Egri TK")
    ("Sütõ András Általános Iskola Gárdonyi Géza Tagiskolája" "Egri TK")
    ("Szihalmi Általános Iskola és Alapfokú Mûvészeti Iskola" "Egri TK")
    ("Szilágyi Erzsébet Gimnázium és Kollégium Mátyás király út 62. szám Alatti Telephelye" "Egri TK")
    ("Szilvásváradi Jókai Mór Általános Iskola" "Egri TK")
    ("Tarnamérai Általános Iskola" "Egri TK")
    ("Verpeléti Arany János Általános Iskola és Reményi Ede Alapfokú Mûvészeti Iskola" "Egri TK")
    ("Andreetti Károly Általános Iskola és Mûvészeti Iskola" "Érdi TK")
    ("Andreetti Károly Általános Iskola és Mûvészeti Iskola Tárnoki Telephelye" "Érdi TK")
    ("Bálint Márton Általános Iskola és Gimnázium Tagintézménye" "Érdi TK")
    ("Biatorbágyi Pászti Miklós Alapfokú Mûvészeti Iskola" "Érdi TK")
    ("Biatorbágyi Pászti Miklós Alapfokú Mûvészeti Iskola Kálvin téri Telephelye" "Érdi TK")
    ("Biatorbágyi Pászti Miklós Alapfokú Mûvészeti Iskola Pátyi Telephelye" "Érdi TK")
    ("Bleyer Jakab Német Nemzetiségi Általános Iskola" "Érdi TK")
    ("Bocskai István Magyar-Német Két Tanítási Nyelvû Általános Iskola" "Érdi TK")
    ("Budakeszi Nagy Sándor József Gimnázium" "Érdi TK")
    ("Budakeszi Széchenyi István Általános Iskola" "Érdi TK")
    ("Budakeszi Széchenyi István Általános Iskola" "Érdi TK")
    ("Budaörsi 1. Számú Általános Iskola" "Érdi TK")
    ("Budaörsi Illyés Gyula Gimnázium, Technikum és Szakképzõ Iskola" "Érdi TK")
    ("Czövek Erna Alapfokú Mûvészeti Iskola Árpád fejedelem tér Telephely" "Érdi TK")
    ("Czövek Erna Alapfokú Mûvészeti Iskola Széchenyi utcaTelephely" "Érdi TK")
    ("Diósdi Eötvös József Német Nemzetiségi Általános Iskola és Alapfokú Mûvészeti Iskola" "Érdi TK")
    ("Érdi Batthyány Sportiskolai Általános Iskola és Gimnázium" "Érdi TK")
    ("Érdi Bolyai János Általános Iskola Alsó utcai telephelye" "Érdi TK")
    ("Érdi Kõrösi Csoma Sándor Általános Iskola" "Érdi TK")
    ("Érdi Kõrösi Csoma Sándor Általános Iskola Bajcsy-Zsilinszky út 13. szám alatti Telephelye" "Érdi TK")
    ("Érdi Móra Ferenc Általános Iskola és Egységes Gyógypedagógiai Módszertani Intézmény Bagoly utcai telephelye" "Érdi TK")
    ("Érdi Móra Ferenc Általános Iskola és Egységes Gyógypedagógiai Módszertani Intézmény piliscsabai telephelye" "Érdi TK")
    ("Érdi Teleki Sámuel Általános Iskola" "Érdi TK")
    ("Érdi Vörösmarty Mihály Gimnázium" "Érdi TK")
    ("Érdligeti Általános Iskola Túr Utcai Telephelye" "Érdi TK")
    ("József Nádor Általános Iskola és Alapfokú Mûvészeti Iskola (ÖKO Iskola"  	"Érdi TK")
    ("Kis-forrás Német Nemzetiségi Általános Iskola" "Érdi TK")
    ("Leopold Mozart Alapfokú Mûvészeti Iskola Esze Tamás utcai telephelye" "Érdi TK")
    ("Leopold Mozart Alapfokú Mûvészeti Iskola Iskola téri telephelye" "Érdi TK")
    ("Lukin László Alapfokú Mûvészeti Iskola Alsó u. 21. telephelye" "Érdi TK")
    ("Lukin László Alapfokú Mûvészeti Iskola Burkoló utca 40. telephelye" "Érdi TK")
    ("Lukin László Alapfokú Mûvészeti Iskola Fácán köz 35. telephelye" "Érdi TK")
    ("Lukin László Alapfokú Mûvészeti Iskola Gárdonyi Géza u. 1/b. telephelye" "Érdi TK")
    ("Lukin László Alapfokú Mûvészeti Iskola Túr u. 5-7. telephelye" "Érdi TK")
    ("Pilisborosjenõi Német Nemzetiségi Általános Iskola és Alapfokú Mûvészeti Iskola" "Érdi TK")
    ("Pilisjászfalui Dózsa György Általános Iskola" "Érdi TK")
    ("Pilisvörösvári Cziffra György Alapfokú Mûvészeti Iskola" "Érdi TK")
    ("Pilisvörösvári Cziffra György Alapfokú Mûvészeti Iskola Petõfi Sándor Utcai Telephelye" "Érdi TK")
    ("Pilisvörösvári Templom Téri Német Nemzetiségi Általános Iskola" "Érdi TK")
    ("Pilisszentiváni Német Nemzetiségi Általános Iskola és Alapfokú Mûvészeti Iskola" "Érdi TK")
    ("Solymári Hunyadi Mátyás Német Nemzetiségi Általános Iskola, Alapfokú Mûvészeti Iskola" "Érdi TK")
    ("Százhalombattai 1. Számú Általános Iskola" "Érdi TK")
    ("Százhalombattai Arany János Általános Iskola és Gimnázium" "Érdi TK")
    ("Százhalombattai Kõrösi Csoma Sándor Sportiskolai Általános Iskola" "Érdi TK")
    ("Tárnoki II. Rákóczi Ferenc Sportiskolai Általános Iskola" "Érdi TK")
    ("Tinnyei Kossuth Lajos Általános Iskola" "Érdi TK")
    ("Zsámbéki Zichy Miklós Általános Iskola" "Érdi TK")
    ("Aelia Sabina Alapfokú Mûvészeti Iskola Arató Emil tér 1. szám alatti Telephelye" "Észak-Budapesti TK")
    ("Aelia Sabina Alapfokú Mûvészeti Iskola Dózsa György utca 42. szám alatti Telephelye" "Észak-Budapesti TK")
    ("Aelia Sabina Alapfokú Mûvészeti Iskola Fodros utca 38-40. szám alatti Telephelye" "Észak-Budapesti TK")
    ("Aelia Sabina Alapfokú Mûvészeti Iskola Kerék utca 18-20. szám alatti Telephelye" "Észak-Budapesti TK")
    ("Aelia Sabina Alapfokú Mûvészeti Iskola Medgyessy Ferenc utca 2-4. szám alatti Telephelye" "Észak-Budapesti TK")
    ("Aelia Sabina Alapfokú Mûvészeti Iskola Szérûskert utca 40. szám alatti Telephelye" "Észak-Budapesti TK")
    ("Aelia Sabina Alapfokú Mûvészeti Iskola Váradi utca 15/b. szám alatti Telephelye" "Észak-Budapesti TK")
    ("Aelia Sabina Alapfokú Mûvészeti Iskola Zápor utca 90. szám alatti Telephelye" "Észak-Budapesti TK")
    ("Aquincum Angol-Magyar Két Tanítási Nyelvû Általános Iskola" "Észak-Budapesti TK")
    ("Budapest III. Kerületi Bárczi Géza Általános Iskola" "Észak-Budapesti TK")
    ("Budapest III. Kerületi Csillagház Gyógypedagógiai Általános Iskola" "	Észak-Budapesti TK")
    ("Budapest III. Kerületi Kerék Általános Iskola és Gimnázium" "Észak-Budapesti TK")
    ("Budapest III. Kerületi Óvoda, Általános Iskola, Egységes Gyógypedagógiai Módszertani Intézmény" "Észak-Budapesti TK")
    ("Budapest III. Kerületi Szent Miklós Óvoda, Általános Iskola, Egységes Gyógypedagógiai Módszertani Intézmény, Kollégium és Gyermekotthon" "Észak-Budapesti TK")
    ("Csillaghegyi Általános Iskola" "Észak-Budapesti TK")
    ("Dr. Béres József Általános Iskola Emõd Utcai Telephelye" "Észak-Budapesti TK")
    ("Elsõ Óbudai Német Nyelvoktató Nemzetiségi Általános Iskola Erste Altofener Deutsche Nationalitätenschule" "Észak-Budapesti TK")
    ("Erkel Gyula Újpesti Zenei Alapfokú Mûvészeti Iskola Bajza utca 2. Telephelye" "	Észak-Budapesti TK")
    ("Erkel Gyula Újpesti Zenei Alapfokú Mûvészeti Iskola Erzsébet utca 31. Telephelye" "	Észak-Budapesti TK")
    ("Erkel Gyula Újpesti Zenei Alapfokú Mûvészeti Iskola Fóti út 66. Telephelye" "	Észak-Budapesti TK")
    ("Erkel Gyula Újpesti Zenei Alapfokú Mûvészeti Iskola Homoktövis utca 100. Telephelye" "	Észak-Budapesti TK")
    ("Erkel Gyula Újpesti Zenei Alapfokú Mûvészeti Iskola Munkásotthon utca 3. Telephelye" "	Észak-Budapesti TK")
    ("Erkel Gyula Újpesti Zenei Alapfokú Mûvészeti Iskola Pozsonyi út 3. Telephelye" "	Észak-Budapesti TK")
    ("Erkel Gyula Újpesti Zenei Alapfokú Mûvészeti Iskola Tanoda tér 6. Telephelye" "	Észak-Budapesti TK")
    ("Fodros Általános Iskola" "Észak-Budapesti TK")
    ("Fõvárosi Iskolaszanatórium Általános Iskola és Gimnázium 1082 Budapest VIII. kerület, Korányi Sándor utca 2. (Ortopédiai Klinika)telephelye" "Észak-Budapesti TK")
    ("Fõvárosi Iskolaszanatórium Általános Iskola és Gimnázium Ali u. 14. (Budai Gyermekkórház) telephelye" "Észak-Budapesti TK")
    ("Fõvárosi Iskolaszanatórium Általános Iskola és Gimnázium Bókay J. u.53. (I.sz. Gyermekklinika) telephelye" "Észak-Budapesti TK")
    ("Fõvárosi Iskolaszanatórium Általános Iskola és Gimnázium Diósárok út 1. (Szent János Kórház) telephelye" "Észak-Budapesti TK")
    ("Fõvárosi Iskolaszanatórium Általános Iskola és Gimnázium Haller u. 29. (Gottsegen György Országos Kardiológiai Intézet) telephelyet" "Észak-Budapesti TK")
    ("Fõvárosi Iskolaszanatórium Általános Iskola és Gimnázium Szanatórium u. 2. (O.O.R.I.) telephelye" "Észak-Budapesti TK")
    ("Fõvárosi Iskolaszanatórium Általános Iskola és Gimnázium Üllõi út 86. (Heim Pál Gyermekkórház) telephelye" "Észak-Budapesti TK")
    ("Medgyessy Ferenc Német Nemzetiségi Nyelvoktató Általános Iskola Ferenc Medgyessy Deutsche Nationalitätengrundschule" "Észak-Budapesti TK")
    ("Óbudai Árpád Gimnázium" "Észak-Budapesti TK")
    ("Óbudai Harrer Pál Angol Nyelvet Emelt Szinten Oktató Általános Iskola" "Észak-Budapesti TK")
    ("Óbudai Nagy László Magyar-Angol Két Tanítási Nyelvû Általános Iskola" "Észak-Budapesti TK")
    ("Óbudai Népzenei Alapfokú Mûvészeti Iskola" "Észak-Budapesti TK")
    ("Pécsi Sebestyén Ének-Zenei Általános Iskola és Alapfokú Mûvészeti Iskola" "Észak-Budapesti TK")
    ("Újpesti Bajza József Általános Iskola" "Észak-Budapesti TK")
    ("Újpesti Bródy Imre Gimnázium és Általános Iskola" "Észak-Budapesti TK")
    ("Újpesti Csokonai Vitéz Mihály Általános Iskola és Gimnázium" "Észak-Budapesti TK")
    ("Újpesti Homoktövis Általános Iskola" "Észak-Budapesti TK")
    ("Újpesti Károlyi István Általános Iskola és Gimnázium" "Észak-Budapesti TK")
    ("Újpesti Óvoda, Általános Iskola, Egységes Gyógypedagógiai Módszertani Intézmény" "Észak-Budapesti TK")
    ("Újpesti Óvoda, Általános Iskola, Egységes Gyógypedagógiai Módszertani Intézmény Mártírok Utcai Telephelye" "Észak-Budapesti TK")
    ("Újpesti Szigeti József Utcai Általános Iskola" "Észak-Budapesti TK")
    ("Vécsey János Leánykollégium" "Észak-Budapesti TK")
    ("Budapest XV. Kerületi Dózsa György Gimnázium és Táncmûvészeti Szakgimnázium Szõdliget u. 24-30. Telephelye" "Észak-Pesti TK")
    ("Budapest XV. Kerületi Károly Róbert Általános Iskola" "Észak-Pesti TK")
    ("Budapest XV. Kerületi László Gyula Gimnázium és Általános Iskola" "Észak-Pesti TK")
    ("Budapest XVI. Kerületi Batthyány Ilona Általános Iskola" "Észak-Pesti TK")
    ("Budapest XVI. Kerületi Batthyány Ilona Általános Iskola Rádió utca 38. alatti Telephelye" "Észak-Pesti TK")
    ("Budapest XVI. Kerületi Jókai Mór Általános Iskola" "Észak-Pesti TK")
    ("Budapest XVI. Kerületi Kölcsey Ferenc Általános Iskola Hõsök tere 3. Telephelye" "Észak-Pesti TK")
    ("Budapest XVI. Kerületi Lemhényi Dezsõ Általános Iskola" "Észak-Pesti TK")
    ("Budapest XVI. Kerületi Rácz Aladár Zene-, Tánc-, Képzõ- és Iparmûvészeti Alapfokú Mûvészeti Iskola" "Észak-Pesti TK")
    ("Budapest XVI. Kerületi Rácz Aladár Zene-, Tánc-, Képzõ- és Iparmûvészeti Alapfokú Mûvészeti Iskola Bekecs utca 62-78. alatti Telephelye" "Észak-Pesti TK")
    ("Budapest XVI. Kerületi Rácz Aladár Zene-, Tánc-, Képzõ- és Iparmûvészeti Alapfokú Mûvészeti Iskola Georgina utca 23. alatti Telephelye" "Észak-Pesti TK")
    ("Budapest XVI. Kerületi Rácz Aladár Zene-, Tánc-, Képzõ- és Iparmûvészeti Alapfokú Mûvészeti Iskola Hõsök tere 1. alatti Telephelye" "Észak-Pesti TK")
    ("Budapest XVI. Kerületi Rácz Aladár Zene-, Tánc-, Képzõ- és Iparmûvészeti Alapfokú Mûvészeti Iskola Metró utca 3-7. alatti Telephelye" "Észak-Pesti TK")
    ("Budapest XVI. Kerületi Rácz Aladár Zene-, Tánc-, Képzõ- és Iparmûvészeti Alapfokú Mûvészeti Iskola Sasvár utca 101. alatti Telephelye" "Észak-Pesti TK")
    ("Budapest XVI. Kerületi Rácz Aladár Zene-,Tánc-,Képzõ- és Iparmûvészeti Alapfokú Mûvészeti Iskola Béla utca 23. alatti telephelye" "Észak-Pesti TK")
    ("Budapest XVI. Kerületi Szent-Györgyi Albert Általános Iskola (002. Telephely" "	Észak-Pesti TK")
    ("Budapest XVI. Kerületi Táncsics Mihály Általános Iskola és Gimnázium" "Észak-Pesti TK")
    ("Corvin Mátyás Gimnázium" "Észak-Pesti TK")
    ("Göllesz Viktor Óvoda, Általános Iskola és Egységes Gyógypedagógiai Módszertani Intézmény" "Észak-Pesti TK")
    ("Göllesz Viktor Óvoda, Általános Iskola és Egységes Gyógypedagógiai Módszertani Intézmény Beszédjavító Általános Iskolája" "Észak-Pesti TK")
    ("Hubay Jenõ Zeneiskola Bogáncs utcai kihelyezett tagozata" "Észak-Pesti TK")
    ("Hubay Jenõ Zeneiskola Kavicsos közi kihelyezett tagozata" "Észak-Pesti TK")
    ("Hubay Jenõ Zeneiskola Kontyfa utcai kihelyezett tagozata" "Észak-Pesti TK")
    ("Hubay Jenõ Zeneiskola Neptun utcai kihelyezett tagozata" "Észak-Pesti TK")
    ("Hubay Jenõ Zeneiskola Széchenyi téri kihelyezett tagozata" "Észak-Pesti TK")
    ("Hubay Jenõ Zeneiskola Tóth István utcai kihelyezett tagozata" "Észak-Pesti TK")
    ("Kontyfa Általános Iskola és Gimnázium" "Észak-Pesti TK")
    ("Pestújhelyi Általános Iskola" "Észak-Pesti TK")
    ("Szent Korona Általános Iskola" "Észak-Pesti TK")
    ("Bajnai Simor János Általános Iskola" "Esztergomi TK")
    ("Dorogi Erkel Ferenc Alapfokú Mûvészeti Iskola" "Esztergomi TK")
    ("Dorogi Erkel Ferenc Alapfokú Mûvészeti Iskola Bajnai Telephelye" "Esztergomi TK")
    ("Dorogi Erkel Ferenc Alapfokú Mûvészeti Iskola Dorog Bécsi úti Telephelye" "Esztergomi TK")
    ("Dorogi Erkel Ferenc Alapfokú Mûvészeti Iskola Kesztölci Telephelye" "Esztergomi TK")
    ("Dorogi Erkel Ferenc Alapfokú Mûvészeti Iskola Nagysápi Telephelye" "Esztergomi TK")
    ("Dorogi Erkel Ferenc Alapfokú Mûvészeti Iskola Tokod Béke utcai Telephelye" "Esztergomi TK")
    ("Dorogi Magyar-Angol Két Tanítási Nyelvû és Sportiskolai Általános Iskola" "Esztergomi TK")
    ("Dorogi Magyar-Angol Két Tanítási Nyelvû és Sportiskolai Általános Iskola Petõfi Sándor Tagiskolája" "Esztergomi TK")
    ("Dorogi Zsigmondy Vilmos Magyar-Angol Két Tanítási Nyelvû Gimnázium" 	"Esztergomi TK")
    ("Esztergomi Dobó Katalin Gimnázium" "Esztergomi TK")
    ("Esztergomi Kõrösy László Középiskolai Kollégium" "Esztergomi TK")
    ("Esztergomi Petõfi Sándor Általános Iskola" "Esztergomi TK")
    ("Lábatlani Arany János Általános Iskola és Alapfokú Mûvészeti Iskola" "Esztergomi TK")
    ("Leányvári Erdély Jenõ Általános Iskola Leányvár, Erzsébet út 98. sz. Alatti Telephelye" "Esztergomi TK")
    ("Nyergesújfalui Kernstok Károly Általános Iskola" "Esztergomi TK")
    ("Nyergesújfalui Kernstok Károly Általános Iskola Tagiskolája" "Esztergomi TK")
    ("Nyergesújfalui Szabolcsi Bence Alapfokú Mûvészeti Iskola Bajóti Telephelye" "Esztergomi TK")
    ("Nyergesújfalui Szabolcsi Bence Alapfokú Mûvészeti Iskola Nyergesújfalui Telephelye" "Esztergomi TK")
    ("Pilismaróti Bozóky Mihály Általános Iskola" "Esztergomi TK")
    ("Sárisáp és Környéke Körzeti Általános Iskola Cser Simon Tagiskolája" "Esztergomi TK")
    ("Sárisáp és Környéke Körzeti Általános Iskola Dági Tagiskolájának Telephelye" "Esztergomi TK")
    ("Táti III. Béla Általános Iskola" "Esztergomi TK")
    ("Táti III. Béla Általános Iskola Mogyorósbányai Tagintézménye" "Esztergomi TK")
    ("Táti Lavotta János Alapfokú Mûvészeti Iskola Mogyorósbányai Telephelye" "Esztergomi TK")
    ("Tokodi Hegyeskõ Általános Iskola" "Esztergomi TK")
    ("Abdai Zrínyi Ilona Általános Iskola" "Gyõri TK")
    ("Abdai Zrínyi Ilona Általános Iskola Ikrényi Tagiskolája" "Gyõri TK")
    ("Bárczi Gusztáv Óvoda, Általános Iskola, Készségfejlesztõ Iskola, Kollégium" "Gyõri TK")
    ("Bõnyi Szent István Király Általános Iskola" "Gyõri TK")
    ("Dr. Batthyány-Strattmann László Általános Iskola" "Gyõri TK")
    ("Dunaszegi Körzeti Általános Iskola Telephelye" "Gyõri TK")
    ("Écsi Petõfi Sándor Általános Iskola és Alapfokú Mûvészeti Iskola 008-as Telephelye" "Gyõri TK")
    ("Enesei Általános Iskola" "Gyõri TK")
    ("Fiáth János Általános Iskola" "Gyõri TK")
    ("Gönyûi Széchenyi István Általános Iskola" "Gyõri TK")
    ("Gyárvárosi Általános Iskola" "Gyõri TK")
    ("Gyõri Fekete István Általános Iskola" "Gyõri TK")
    ("Gyõri Kodály Zoltán Ének-zenei Általános Iskola" "Gyõri TK")
    ("Gyõri Kossuth Lajos Általános Iskola Burcsellás közi Telephelye" "Gyõri TK")
    ("Gyõri Kovács Margit Német Nyelvoktató Nemzetiségi Általános Iskola, Alapfokú Mûvészeti Iskola és Iparmûvészeti Szakgimnázium" "Gyõri TK")
    ("Gyõri Ménfõcsanaki Petõfi Sándor Általános Iskola" "Gyõri TK")
    ("Gyõri Móricz Zsigmond Általános Iskola" "Gyõri TK")
    ("Gyõri Radnóti Miklós Általános Iskola" "Gyõri TK")
    ("Gyõri Tulipános Általános Iskola" "Gyõri TK")
    ("Gyõrladamér Községi Általános Iskola" "Gyõri TK")
    ("Gyõr-Moson-Sopron Vármegyei Pedagógiai Szakszolgálat" "Gyõri TK")
    ("Gyõr-Moson-Sopron Vármegyei Pedagógiai Szakszolgálat Gyõri Tagintézménye" "Gyõri TK")
    ("Gyõr-Moson-Sopron Vármegyei Pedagógiai Szakszolgálat Kapuvári Tagintézménye" 	"Gyõri TK")
    ("Gyõr-Moson-Sopron Vármegyei Pedagógiai Szakszolgálat Mosonmagyaróvári Tagintézménye" "Gyõri TK")
    ("Gyõr-Moson-Sopron Vármegyei Pedagógiai Szakszolgálat Mosonmagyaróvári Tagintézménye Hegyeshalmi telephelye" "Gyõri TK")
    ("Gyõr-Moson-Sopron Vármegyei Pedagógiai Szakszolgálat Pannonhalmi Tagintézménye" "Gyõri TK")
    ("Gyõr-Moson-Sopron Vármegyei Pedagógiai Szakszolgálat Soproni Tagintézménye" "Gyõri TK")
    ("Gyõr-Moson-Sopron Vármegyei Pedagógiai Szakszolgálat Téti Tagintézménye telephelye" "Gyõri TK")
    ("Gyõrzámolyi Petõfi Sándor Általános Iskola" "Gyõri TK")
    ("Háry László Általános Iskola 001-es Telephelye" "Gyõri TK")
    ("Jánossomorjai Körzeti Általános Iskola és Alapfokú Mûvészeti Iskola" "Gyõri TK")
    ("Jánossomorjai Körzeti Általános Iskola és Alapfokú Mûvészeti Iskola Óvári Utcai Telephelye" "Gyõri TK")
    ("Kisbajcsi Vörösmarty Mihály Általános Iskola és Alapfokú Mûvészeti Iskola" "Gyõri TK")
    ("Kisfaludy Károly Általános Iskola és Alapfokú Mûvészeti Iskola" "Gyõri TK")
    ("Kisfaludy Károly Általános Iskola és Alapfokú Mûvészeti Iskola Gyõrszemerei Tagiskolájának Telephelye" "Gyõri TK")
    ("Kisfaludy Károly Általános Iskola és Alapfokú Mûvészeti Iskola Rábacsécsényi Tagiskolája" "Gyõri TK")
    ("Kossuth Zsuzsanna Leánykollégium" "Gyõri TK")
    ("Lébényi Általános Iskola és Alapfokú Mûvészeti Iskola Bezi Telephelye" "Gyõri TK")
    ("Lébényi Általános Iskola és Alapfokú Mûvészeti Iskola Iskola u. 1 sz. alatti Telephelye" "Gyõri TK")
    ("Levéli Német Nemzetiségi Általános Iskola" "Gyõri TK")
    ("Liszt Ferenc Zenei Alapfokú Mûvészeti Iskola Sövény utcai telephelye" "Gyõri TK")
    ("Liszt Ferenc Zeneiskola-Alapfokú Mûvészeti Iskola Baross Gábor Úti Telephelye" "Gyõri TK")
    ("Liszt Ferenc Zeneiskola-Alapfokú Mûvészeti Iskola Kisdobos úti Telephelye" "Gyõri TK")
    ("Liszt Ferenc Zeneiskola-Alapfokú Mûvészeti Iskola Örkény István utcai Telephelye" "Gyõri TK")
    ("Liszt Ferenc Zeneiskola-Alapfokú Mûvészeti Iskola Péterfy Sándor utcai telephelye" "Gyõri TK")
    ("Liszt Ferenc Zeneiskola-Alapfokú Mûvészeti Iskola Szent Imre Úti Telephelye" "Gyõri TK")
    ("Liszt Ferenc Zeneiskola-Alapfokú Mûvészeti Iskola Váci Mihály úti Telephelye" "Gyõri TK")
    ("Lõrincze Lajos Általános Iskola" "Gyõri TK")
    ("Mosonmagyaróvári Éltes Mátyás Általános Iskola, Óvoda, Készségfejlesztõ Iskola, Kollégium, Egységes Gyógypedagógiai Módszertani Intézmény" "Gyõri TK")
    ("Mosonmagyaróvári Fekete István Általános Iskola" "Gyõri TK")
    ("Mosonmagyaróvári Kossuth Lajos Gimnázium és Kollégium" "Gyõri TK")
    ("Mosonszentmiklósi Széchenyi István Általános Iskola és Alapfokú Mûvészeti Iskola" "Gyõri TK")
    ("Mosonyi Mihály Zenei Alapfokú Mûvészeti Iskola" "Gyõri TK")
    ("Nagyszentjánosi Hunyadi Mátyás Általános Iskola" "Gyõri TK")
    ("Péri Öveges József Általános Iskola" "Gyõri TK")
    ("Rábapatonai Petõfi Sándor Általános Iskola" "Gyõri TK")
    ("Radó Tibor Általános Iskola és Egységes Gyógypedagógiai Módszertani Intézmény 002-es Telephelye" "Gyõri TK")
    ("Révai Miklós Gimnázium és Kollégium" "Gyõri TK")
    ("Richter János Zenemûvészeti Szakgimnázium, Általános Iskola, Alapfokú Mûvészeti Iskola és Kollégium" "Gyõri TK")
    ("Sokorópátkai Általános Iskola" "Gyõri TK")
    ("Szabadhegyi Magyar-Német Két Tanítási Nyelvû Általános Iskola és Gimnázium" "Gyõri TK")
    ("Szigetköz Körzeti Általános Iskola és Alapfokú Mûvészeti Iskola" "Gyõri TK")
    ("Tápi József Attila Általános Iskola" "Gyõri TK")
    ("Tápszentmiklósi Csokonai Vitéz Mihály Általános Iskola Gyõrasszonyfai Telephelye" "Gyõri TK")
    ("Tényõi Ady Endre Általános Iskola" "Gyõri TK")
    ("Veszprémvarsányi Fekete István Általános Iskola és Alapfokú Mûvészeti Iskola" "Gyõri TK")
    ("Bucsai II. Rákóczi Ferenc Általános Iskola és Alapfokú Mûvészeti Iskola Bocskai Utcai Telephelye" "Gyulai TK")
    ("Dr. Hepp Ferenc Általános Iskola" "Gyulai TK")
    ("Dr. Illyés Sándor Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Kollégium és Egységes Gyógypedagógiai Módszertani Intézmény" "Gyulai TK")
    ("Dr. Mester György Általános Iskola" "Gyulai TK")
    ("Gyomaendrõdi Kis Bálint Általános Iskola" "Gyulai TK")
    ("Gyulai Dürer Albert Általános Iskola" "Gyulai TK")
    ("Gyulai Dürer Albert Általános Iskola Bay Zoltán Általános Iskola Tagintézménye" "Gyulai TK")
    ("Gyulai Erkel Ferenc Alapfokú Mûvészeti Iskola Ady Endre Utcai Telephelye" "Gyulai TK")
    ("Gyulai Erkel Ferenc Alapfokú Mûvészeti Iskola Eleki - Szent István utcai Telephelye" "Gyulai TK")
    ("Gyulai Erkel Ferenc Alapfokú Mûvészeti Iskola Lökösházi Telephelye" "Gyulai TK")
    ("Gyulai Erkel Ferenc Alapfokú Mûvészeti Iskola Sarkadi - Gyulai Úti Telephelye" "Gyulai TK")
    ("Gyulai Erkel Ferenc Alapfokú Mûvészeti Iskola Szabadkígyósi Telephelye" "Gyulai TK")
    ("Gyulai Erkel Ferenc Alapfokú Mûvészeti Iskola Újkígyósi - Petõfi Sándor utcai Telephelye" "Gyulai TK")
    ("Gyulai Erkel Ferenc Gimnázium és Kollégium-Kollégium Telephelye" "Gyulai TK")
    ("Gyulai Implom József Általános Iskola 5. Sz. Általános Iskola és Sportiskola Tagintézménye" "Gyulai TK")
    ("Kállai Ferenc Alapfokú Mûvészeti Iskola Csárdaszállási Telephelye" "Gyulai TK")
    ("Kállai Ferenc Alapfokú Mûvészeti Iskola Kossuth Lajos utcai telephelye" "Gyulai TK")
    ("Kállai Ferenc Alapfokú Mûvészeti Iskola Selyem utcai telephelye" "Gyulai TK")
    ("Kossuth Lajos Általános Iskola és Alapfokú Mûvészeti Iskola" "Gyulai TK")
    ("Kossuth Lajos Általános Iskola és Alapfokú Mûvészeti Iskola - Hegyesi utcai Telephelye" "Gyulai TK")
    ("Köröstarcsai Arany Gusztáv Általános Iskola Kossuth Utca 4 Alatti Telephelye" "Gyulai TK")
    ("Méhkeréki Román Nemzetiségi Kétnyelvû Általános Iskola" "Gyulai TK")
    ("Mezõberényi Általános Iskola Bélmegyeri telephelye" "Gyulai TK")
    ("Mezõgyáni Általános Iskola" "Gyulai TK")
    ("Okányi Általános Iskola" "Gyulai TK")
    ("Okányi Általános Iskola Telephelye" "Gyulai TK")
    ("Pánczél Imre Óvoda, Általános Iskola, Készségfejlesztõ Iskola, Kollégium és Egységes Gyógypedagógiai Módszertani Intézmény Telephelye" "Gyulai TK")
    ("Péter András Gimnázium és Kollégium Ady Endre utca 1/A. Telephelye" "Gyulai TK")
    ("Rózsahegyi Kálmán Általános Iskola Csárdaszállási Telephelye" "Gyulai TK")
    ("Sarkadi Általános Iskola Gyulai úti Telephelye" "Gyulai TK")
    ("Szabó Pál Általános Iskola és Alapfokú Mûvészeti Iskola" "Gyulai TK")
    ("Szokolay Sándor Alapfokú Mûvészeti Iskola" "Gyulai TK")
    ("Szokolay Sándor Alapfokú Mûvészeti Iskola Köröstarcsai Telephelye" "Gyulai TK")
    ("Szokolay Sándor Alapfokú Mûvészeti Iskola Tarhos Telephelye" "Gyulai TK")
    ("Tildy Zoltán Általános Iskola és Alapfokú Mûvészeti Iskola Dózsa György utca 13-17. szám alatti telephelye" "Gyulai TK")
    ("Tüköry Lajos Általános Iskola és Alapfokú Mûvészeti Iskola" "Gyulai TK")
    ("Ványai Ambrus Általános Iskola és Alapfokú Mûvészeti Iskola Ecsegfalvai Telephelye" "Gyulai TK")
    ("Ványai Ambrus Általános Iskola és Alapfokú Mûvészeti Iskola Körösladányi úti Telephelye" "Gyulai TK")
    ("Balmazújvárosi Alapfokú Mûvészeti Iskola" "Hajdúböszörményi TK")
    ("Balmazújvárosi Alapfokú Mûvészeti Iskola Tiszacsegei Telephelye" "Hajdúböszörményi TK")
    ("Balmazújvárosi Általános Iskola" "Hajdúböszörményi TK")
    ("Balmazújvárosi Általános Iskola Kalmár Zoltán Tagintézménye" "Hajdúböszörményi TK")
    ("Bocskai Általános Iskola Makláry Lajos Alapfokú Mûvészeti Tagintézménye" "Hajdúböszörményi TK")
    ("Bocskai István Általános Iskola, Alapfokú Mûvészeti Iskola és Kollégium" "Hajdúböszörményi TK")
    ("Bocskai István Általános Iskola, Alapfokú Mûvészeti Iskola és Kollégium Polgári utcai Telephelye" "Hajdúböszörményi TK")
    ("Dr. Molnár István EGYMI Kalkuttai Teréz Anya Tagintézménye" "Hajdúböszörményi TK")
    ("Földi János Két Tanítási Nyelvû Általános Iskola és Alapfokú Mûvészeti Iskola" "Hajdúböszörményi TK")
    ("Földi János Két Tanítási Nyelvû Általános Iskola és Alapfokú Mûvészeti Iskola Szilágyi Dániel Úti Tagintézménye" "Hajdúböszörményi TK")
    ("Hajdúböszörményi Bartók Béla Alapfokú Mûvészeti Iskola" "Hajdúböszörményi TK")
    ("Hajdúböszörményi Bartók Béla Alapfokú Mûvészeti Iskola 006-os Telephelye" "Hajdúböszörményi TK")
    ("Hajdúböszörményi Bartók Béla Alapfokú Mûvészeti Iskola 013-as Telephelye" "Hajdúböszörményi TK")
    ("Hajdúböszörményi Bartók Béla Alapfokú Mûvészeti Iskola 015-ös Telephelye" "Hajdúböszörményi TK")
    ("Hajdúböszörményi Bartók Béla Alapfokú Mûvészeti Iskola Árpád u. 22. szám alatti telephelye" "Hajdúböszörményi TK")
    ("Hajdúböszörményi Bartók Béla Alapfokú Mûvészeti Iskola Dobó István Utcai Telephelye" "Hajdúböszörményi TK")
    ("Hajdúböszörményi Bartók Béla Alapfokú Mûvészeti Iskola Eötvös utca 9. szám alatti telephelye" "Hajdúböszörményi TK")
    ("Hajdúböszörményi Bartók Béla Alapfokú Mûvészeti Iskola Zólyom Utcai Telephelye" "Hajdúböszörményi TK")
    ("Hajdúböszörményi Bocskai István Általános Iskola" "Hajdúböszörményi TK")
    ("Hajdúböszörményi Bocskai István Általános Iskola Polgári utcai telephelye" "Hajdúböszörményi TK")
    ("Hajdúböszörményi Eötvös József Magyar-Angol Két Tanítási Nyelvû Általános Iskola" "Hajdúböszörményi TK")
    ("Hajdúböszörményi Eötvös József Magyar-Angol Két Tanítási Nyelvû Általános Iskola Eötvös u. 9. telephelye" "Hajdúböszörményi TK")
    ("Hortobágyi Petõfi Sándor Általános Iskola és Kollégium" "Hajdúböszörményi TK")
    ("Tiszacsegei Fekete István Általános Iskola" "Hajdúböszörményi TK")
    ("Újtikos-Tiszagyulaháza Általános Iskola" "Hajdúböszörményi TK")
    ("Zeleméry László Általános Iskola" "Hajdúböszörményi TK")
    ("Atkári Petõfi Sándor Általános Iskola" "Hatvani TK")
    ("Boldogi Berecz Antal Általános Iskola" "Hatvani TK")
    ("Csányi Szent György Általános Iskola" "Hatvani TK")
    ("Detki Petõfi Sándor Általános Iskola Ludasi Telephelye" "Hatvani TK")
    ("Domoszlói III. András Általános Iskola" "Hatvani TK")
    ("Domoszlói III. András Általános Iskola Markazi Várvölgye Tagintézménye" "Hatvani TK")
    ("Fáy András Általános Iskola és Alapfokú Mûvészeti Iskola" "Hatvani TK")
    ("Gyöngyöshalászi Széchenyi István Általános Iskola" "Hatvani TK")
    ("Gyöngyösi Berze Nagy János Gimnázium" "Hatvani TK")
    ("Gyöngyösi Egressy Béni Két Tanítási Nyelvû Általános Iskola" "Hatvani TK")
    ("Gyöngyösi Kálváriaparti Sport- és Általános Iskola" "Hatvani TK")
    ("Gyöngyösi Petõfi Sándor Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola és Készségfejlesztõ Speciális Szakiskola Petõfi Sándor utca 75.szám alatti Telephelye" "Hatvani TK")
    ("Gyöngyöstarjáni Kányádi Sándor Általános Iskola" "Hatvani TK")
    ("Hatvani 5. Számú Általános Iskola" "Hatvani TK")
    ("Hatvani Kodály Zoltán Értékközvetítõ és Képességfejlesztõ Általános Iskola" "Hatvani TK")
    ("Hatvani Lesznai Anna Óvoda, Általános Iskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelést - Oktatást Végzõ Iskola és Egységes Gyógypedagógiai Módszertani Intézmény" "Hatvani TK")
    ("Herédi Általános Iskola" "Hatvani TK")
    ("Horti Batthyány József Általános Iskola Telephelye" "Hatvani TK")
    ("Kocsis Albert Alapfokú Mûvészeti Iskola" "Hatvani TK")
    ("Kocsis Albert Alapfokú Mûvészeti Iskola" "Hatvani TK")
    ("Kocsis Albert Alapfokú Mûvészeti Iskola" "Hatvani TK")
    ("Kocsis Albert Alapfokú Mûvészeti Iskola" "Hatvani TK")
    ("Kocsis Albert Alapfokú Mûvészeti Iskola 1.számú telephelye" "Hatvani TK")
    ("Kocsis Albert Alapfokú Mûvészeti Iskola 3.számú telephelye" "Hatvani TK")
    ("Lõrinci Hunyadi Mátyás Általános Iskola" "Hatvani TK")
    ("Nagyfügedi Arany János Általános Iskola" "Hatvani TK")
    ("Nagyrédei Szent Imre Általános Iskola" "Hatvani TK")
    ("Pétervásárai Tamási Áron Általános Iskola" "Hatvani TK")
    ("Recski Jámbor Vilmos Általános Iskola Mátraballai Telephelye" "Hatvani TK")
    ("Rózsaszentmártoni Móra Ferenc Általános Iskola" "Hatvani TK")
    ("Utassy József Általános Iskola" "Hatvani TK")
    ("Visontai Szent-Györgyi Albert Általános Iskola Telephelye" "Hatvani TK")
    ("Viszneki Általános Iskola Telephelye" "Hatvani TK")
    ("Csanádpalotai Dér István Általános Iskola Ambrózfalvi Telephelye" "Hódmezõvásárhelyi TK")
    ("Csanádpalotai Dér István Általános Iskola Szent István Utcai Telephelye" "Hódmezõvásárhelyi TK")
    ("Csongrád és Térsége Általános Iskola Galli János Általános Iskolája és Alapfokú Mûvészeti Iskolája" "Hódmezõvásárhelyi TK")
    ("Csongrád és Térsége Általános Iskola Galli János Általános Iskolája és Alapfokú Mûvészeti Iskolája Petõfi Sándor Úti Telephelye" "Hódmezõvásárhelyi TK")
    ("Csongrád és Térsége Általános Iskola Piroskavárosi Általános Iskolája" "Hódmezõvásárhelyi TK")
    ("Csongrád és Térsége Széchenyi István Általános Iskola és Alapfokú Mûvészeti Iskola" 	"Hódmezõvásárhelyi TK")
    ("Csongrádi Batsányi János Gimnázium és Kollégium karbantartó mûhely, Apponyi Utcai Telephely" "Hódmezõvásárhelyi TK")
    ("Fábiánsebestyéni Arany János Általános Iskola" "Hódmezõvásárhelyi TK")
    ("Földeáki Návay Lajos Általános Iskola Gagarin utca 30. szám alatti Telephelye" "Hódmezõvásárhelyi TK")
    ("Hódmezõvásárhelyi Klauzál Gábor Általános Iskola" "Hódmezõvásárhelyi TK")
    ("Hódmezõvásárhelyi Klauzál Gábor Általános Iskola Nádor utcai Telephelye" "Hódmezõvásárhelyi TK")
    ("Hódmezõvásárhelyi Szent István Általános Iskola Koczka Utcai Telephelye" "Hódmezõvásárhelyi TK")
    ("Hódmezõvásárhelyi Varga Tamás Általános Iskola" "Hódmezõvásárhelyi TK")
    ("Kiszombori Dózsa György Általános Iskola" "Hódmezõvásárhelyi TK")
    ("Kozmutza Flóra Általános Iskola és Szakiskola Csongrádi Tagintézménye" "Hódmezõvásárhelyi TK")
    ("Kozmutza Flóra Általános Iskola és Szakiskola Pápay Endre Óvoda, Általános Iskola, Szakiskola, Kollégium és Egységes Gyógypedagógiai Módszertani Intézmény" "Hódmezõvásárhelyi TK")
    ("Kozmutza Flóra Általános Iskola és Szakiskola Pápay Endre Óvoda, Általános Iskola, Szakiskola, Kollégium és Egységes Gyógypedagógiai Módszertani Intézmény Kiss Ernõ Utcai 10590/1. hrsz Telephelye" "Hódmezõvásárhelyi TK")
    ("Kozmutza Flóra Óvoda, Általános Iskola, Szakiskola, Kollégium, Egységes Gyógypedagógiai Módszertani Intézmény" "Hódmezõvásárhelyi TK")
    ("Kozmutza Flóra Óvoda, Általános Iskola, Szakiskola, Kollégium, Egységes Gyógypedagógiai Módszertani Intézmény Simonyi Utcai Telephelye" "Hódmezõvásárhelyi TK")
    ("Makói Általános Iskola és Alapfokú Mûvészeti Iskola Apátfalvai Telephelye" "Hódmezõvásárhelyi TK")
    ("Makói Általános Iskola és Alapfokú Mûvészeti Iskola Csanádpalotai Telephelye" "Hódmezõvásárhelyi TK")
    ("Makói Általános Iskola és Alapfokú Mûvészeti Iskola Makói Telephelye" "Hódmezõvásárhelyi TK")
    ("Makói József Attila Gimnázium" "Hódmezõvásárhelyi TK")
    ("Mindszenti Általános Iskola" "Hódmezõvásárhelyi TK")
    ("Nagymágocsi Hunyadi János Általános Iskola" "Hódmezõvásárhelyi TK")
    ("Péczely Attila Alapfokú Mûvészeti Iskola" "Hódmezõvásárhelyi TK")
    ("Péczely Attila Alapfokú Mûvészeti Iskola Hódmezõvásárhely Deák Ferenc u. 4. szám alatti telephelye" "Hódmezõvásárhelyi TK")
    ("Péczely Attila Alapfokú Mûvészeti Iskola hódmezõvásárhely Holló u. 36. szám alatti telephelye" "Hódmezõvásárhelyi TK")
    ("Péczely Attila Alapfokú Mûvészeti Iskola Hódmezõvásárhely Klauzál u. 63. szám alatti telephelye" "Hódmezõvásárhelyi TK")
    ("Péczely Attila alapfokú Mûvészeti Iskola Hódmezõvásárhely Németh László u. 16.szám alatti telephelye" "Hódmezõvásárhelyi TK")
    ("Péczely Attila alapfokú Mûvészeti Iskola Hódmezõvásárhely Szent István tér 2. szám alatti telephelye" "Hódmezõvásárhelyi TK")
    ("Péczely Attila Alapfokú Mûvészeti Iskola Hódmezõvásárhely Szent István u. 75. szám alatti telephelye" "Hódmezõvásárhelyi TK")
    ("Péczely Attila Alapfokú Mûvészeti iskola Mindszent Iskola u. 72-76. szám alatti telephelye" "Hódmezõvásárhelyi TK")
    ("Péczely Attila Alapfokú Mûvészeti Iskola Székkutas József Attila u.1. szám alatti telephelye" "Hódmezõvásárhelyi TK")
    ("Szegvári Forray Máté Általános Iskola Régiposta utca 1/b. szám alatti Telephelye" "Hódmezõvásárhelyi TK")
    ("Szentesi Klauzál Gábor Általános Iskola" "Hódmezõvásárhelyi TK")
    ("Szentesi Koszta József Általános Iskola Derekegyházi Tagintézménye" "Hódmezõvásárhelyi TK")
    ("Szentesi Lajtha László Alapfokú Mûvészeti Iskola Deák Ferenc Utcai Telephelye" "Hódmezõvásárhelyi TK")
    ("Szentesi Lajtha László Alapfokú Mûvészeti Iskola Fábiánsebestyén, Iskola Téri Telephelye" "Hódmezõvásárhelyi TK")
    ("Szentesi Lajtha László Alapfokú Mûvészeti Iskola Kossuth Téri Telephelye" "Hódmezõvásárhelyi TK")
    ("Szentesi Lajtha László Alapfokú Mûvészeti Iskola Nagymágocs, Rákóczi Ferenc Utcai Telephelye" "Hódmezõvásárhelyi TK")
    ("Szentesi Lajtha László Alapfokú Mûvészeti Iskola Szent Imre herceg utcai telephelye" "Hódmezõvásárhelyi TK")
    ("Alsójászsági Általános Iskola Gerevich Aladár Általános Iskolai Tagintézménye" "Jászberényi TK")
    ("Bercsényi Miklós Általános Iskola" "Jászberényi TK")
    ("Csete Balázs Általános Iskola" "Jászberényi TK")
    ("Csete Balázs Általános Iskola Csete Balázs Helytörténeti Gyûjtemény Telephelye" "Jászberényi TK")
    ("Csete Balázs Általános Iskola Jubileum téri Telephelye" "Jászberényi TK")
    ("Jászapáti Általános és Alapfokú Mûvészeti Iskola Damjanich 4. Telephelye" "Jászberényi TK")
    ("Jászapáti Általános Iskola és Alapfokú Mûvészeti Iskola Dr. Szlovencsák Imre úti telephelye" "Jászberényi TK")
    ("Jászapáti Általános Iskola és Alapfokú Mûvészeti Iskola Petõfi Sándor úti telephelye" "Jászberényi TK")
    ("Jászárokszállási Széchenyi István Általános Iskola és Alapfokú Mûvészeti Iskola" "Jászberényi TK")
    ("Jászárokszállási Széchenyi István Általános Iskola és Alapfokú Mûvészeti Iskola Szent Vince utcai telephelye" "Jászberényi TK")
    ("Jászsági Általános Iskola Bozóky János Általános Iskolai Tagintézménye" "Jászberényi TK")
    ("Jászsági Általános Iskola Hunyadi Mátyás Általános Iskolai Tagintézménye" "Jászberényi TK")
    ("Jászsági Általános Iskola Jászágói Általános Iskolai Telephelye" "Jászberényi TK")
    ("Jászsági Gróf Apponyi Albert Általános Iskola és Alapfokú Mûvészeti Iskola" "Jászberényi TK")
    ("Kunráth Sándor Általános Iskola és Alapfokú Mûvészeti Iskola Mártírok út 19. sz. Alatti Telephelye" "Jászberényi TK")
    ("Kunráth Sándor Általános Iskola és Alapfokú Mûvészeti Iskola Rákóczi Úti Telephelye" "Jászberényi TK")
    ("Lehel Vezér Gimnázium Pethes Imre Úti Telephelye" "Jászberényi TK")
    ("Mátyás Király Általános Iskola Telephelye" "Jászberényi TK")
    ("Palotásy János Zeneiskola Alapfokú Mûvészeti Iskola Bajcsy-Zsilinszky Utcai Telephelye" "Jászberényi TK")
    ("Rácz Aladár Zeneiskola Alapfokú Mûvészeti Iskola" "Jászberényi TK")
    ("Rácz Aladár Zeneiskola Alapfokú Mûvészeti Iskola -Jászszentandrás" "Jászberényi TK")
    ("Székely Mihály Általános Iskola Telephelye" "Jászberényi TK")
    ("Szent István Körúti Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Szakiskola és Készségfejlesztõ Iskola Bajcsy-Zsilinszky Utcai Telephelye" "Jászberényi TK")
    ("Szent István Körúti Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Szakiskola és Készségfejlesztõ Iskola-Petõfi úti telephelye" "Jászberényi TK")
    ("Szent István Sport Általános Iskola és Gimnázium Telephelye" "Jászberényi TK")
    ("Bárczi Gusztáv Gyógypedagógiai Módszertani Intézmény Nagybajomi Tagintézménye" "Kaposvári TK")
    ("Barcsi Arany János Általános Iskola" "Kaposvári TK")
    ("Barcsi Deák Ferenc Általános Iskola Bolhói Telephelye" "Kaposvári TK")
    ("Barcsi Deák Ferenc Sportiskolai Általános Iskola" "Kaposvári TK")
    ("Barcsi Szivárvány Óvoda, Általános Iskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelés-Oktatást Végzõ Iskola, Kollégium, Egységes Gyógypedagógiai Módszertani Intézmény" "Kaposvári TK")
    ("Barcsi Vikár Béla Alapfokú Mûvészeti Iskola Darányi Telephelye" "Kaposvári TK")
    ("Barcsi Vikár Béla Alapfokú Mûvészeti Iskola Hõsök terei Telephelye" "Kaposvári TK")
    ("Csökölyi Általános Iskola" "Kaposvári TK")
    ("Csurgói Eötvös József Általános Iskola II. Rákóczi Ferenc Általános Iskolája Telephelye" "Kaposvári TK")
    ("Csurgói Eötvös József Sportiskolai Általános Iskola" "Kaposvári TK")
    ("Drávamenti Körzeti Általános Iskola Darányi Tagiskolája" "Kaposvári TK")
    ("Együd Árpád Alapfokú Mûvészeti Iskola" "Kaposvári TK")
    ("Együd Árpád Alapfokú Mûvészeti Iskola Kaposmérõi Telephelye" "Kaposvári TK")
    ("Együd Árpád Alapfokú Mûvészeti Iskola Szentbalázsi Telephelye" "Kaposvári TK")
    ("Görgetegi Általános Iskola" "Kaposvári TK")
    ("Homokszentgyörgyi I. István Általános Iskola" "Kaposvári TK")
    ("Homokszentgyörgyi I. István Általános Iskola Kálmáncsai Telephelye" "Kaposvári TK")
    ("Iharosberényi Körzeti Általános Iskola" "Kaposvári TK")
    ("Jálics Ernõ Általános Iskola és Kollégium" "Kaposvári TK")
    ("Kaposmérõi Hunyadi János Általános Iskola" 	"Kaposvári TK")
    ("Kaposvári Klebelsberg Középiskolai Kollégium" "Kaposvári TK")
    ("Kaposvári Kodály Zoltán Központi Általános Iskola Benedek Elek Tagiskolája" "Kaposvári TK")
    ("Kaposvári Kodály Zoltán Központi Általános Iskola Honvéd Utcai Tagiskolája" "Kaposvári TK")
    ("Kaposvári Kodály Zoltán Központi Általános Iskola Kinizsi Lakótelepi Tagiskolája" "Kaposvári TK")
    ("Kaposvári Kodály Zoltán Központi Általános Iskola Toldi Lakótelepi Tagiskolája" "Kaposvári TK")
    ("Kaposvári Kodály Zoltán Központi Általános Iskola Zrínyi Ilona Magyar-Angol Két Tanítási Nyelvû Tagiskolája" "Kaposvári TK")
    ("Kaposvári Liszt Ferenc Zeneiskola-Alapfokú Mûvészeti Iskola Fõ utcai Telephelye" "Kaposvári TK")
    ("Kaposvári Liszt Ferenc Zeneiskola-Alapfokú Mûvészeti Iskola Kaposmérõi Telephelye" "Kaposvári TK")
    ("Kaposvári Liszt Ferenc Zeneiskola-Alapfokú Mûvészeti Iskola Pázmány Péter utcai telephelye" "Kaposvári TK")
    ("Kaposvári Liszt Ferenc Zeneiskola-Alapfokú Mûvészeti Iskola Szent Imre utcai Telephelye" "Kaposvári TK")
    ("Kaposvári Liszt Ferenc Zeneiskola-Alapfokú Mûvészeti Iskola Toponári Telephelye" "Kaposvári TK")
    ("Kaposvári Táncsics Mihály Gimnázium" "Kaposvári TK")
    ("Kavulák János Általános Iskola" "Kaposvári TK")
    ("Mernyei Szabadi Gábor Általános Iskola" "Kaposvári TK")
    ("Mezõcsokonyai Általános Iskola" "Kaposvári TK")
    ("Nagyatádi Általános Iskola Árpád Fejedelem Tagintézménye" "Kaposvári TK")
    ("Nagyatádi Bárdos Lajos Sport Általános Iskola és Alapfokú Mûvészeti Iskola Taranyi Telephelye" "Kaposvári TK")
    ("Nagyatádi Éltes Mátyás Óvoda, Általános Iskola, Fejlesztõ Nevelés-Oktatást Végzõ Iskola, Egységes Gyógypedagógiai Módszertani Intézmény" "Kaposvári TK")
    ("Nagybajomi Csokonai Vitéz Mihály Általános Iskola és Kollégium Kollégiumi Tagintézménye" "Kaposvári TK")
    ("Segesdi IV. Béla Király Általános Iskola" "Kaposvári TK")
    ("Somogy Vármegyei Pedagógiai Szakszolgálat" "Kaposvári TK")
    ("Somogy Vármegyei Pedagógiai Szakszolgálat Barcsi Tagintézménye Széchenyi utcai Telephelye" "Kaposvári TK")
    ("Somogy Vármegyei Pedagógiai Szakszolgálat Fonyódi Tagintézmény Balatonlellei Telephelye" "Kaposvári TK")
    ("Somogy Vármegyei Pedagógiai Szakszolgálat Kaposvári Tagintézmény Kadarkúti Telephelye" "Kaposvári TK")
    ("Somogy Vármegyei Pedagógiai Szakszolgálat Kaposvári Tagintézménye" "Kaposvári TK")
    ("Somogy Vármegyei Pedagógiai Szakszolgálat Marcali Tagintézménye" "Kaposvári TK")
    ("Somogy Vármegyei Pedagógiai Szakszolgálat Siófoki Tagintézménye" "Kaposvári TK")
    ("Somogyjádi Illyés Gyula Általános Iskola" "Kaposvári TK")
    ("Somogyjádi Illyés Gyula Általános Iskola Osztopáni Telephelye" "Kaposvári TK")
    ("Somssich Imre Általános Iskola" "Kaposvári TK")
    ("Szennai Fekete László Általános Iskola" "Kaposvári TK")
    ("Szennai Fekete László Általános Iskola Kaposfõi Tagintézménye" "Kaposvári TK")
    ("Taszári Fésûs Éva Általános Iskola" "Kaposvári TK")
    ("Zákányi Zrínyi Miklós Általános Iskola" "Kaposvári TK")
    ("Abádszalóki Kovács Mihály Általános Iskola Tiszaderzsi Telephelye" "Karcagi TK")
    ("Fegyverneki Móra Ferenc Általános Iskola" "Karcagi TK")
    ("Fegyverneki Móra Ferenc Általános Iskola telephelye" 	"Karcagi TK")
    ("Fekete László Zeneiskola - Alapfokú Mûvészeti Iskola Tiszaderzsi Telephelye" "Karcagi TK")
    ("Fekete László Zeneiskola - Alapfokú Mûvészeti Iskola Tiszaszentimrei Telephelye" "Karcagi TK")
    ("Fekete László Zeneiskola Alapfokú Mûvészeti Iskola Abádszalóki Telephely" "Karcagi TK")
    ("Fekete László Zeneiskola alapfokú Mûvészeti Iskola Tomajmonostorai Telephely" "Karcagi TK")
    ("Hunyadi Mátyás Magyar - Angol Két Tanítási Nyelvû Általános Iskola Kossuth Téri Telephelye" "Karcagi TK")
    ("Hunyadi Mátyás Magyar-Angol Két Tanítási Nyelvû Általános Iskola" "Karcagi TK")
    ("Kádas György Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola és Kollégium" "Karcagi TK")
    ("Kádas György Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola és Kollégium Karcagi Tagintézményének "Zártkert" Telephelye" "Karcagi TK")
    ("Kádas György Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola és Kollégium Karcagi Tagintézményének Futó Imre u.3. sz. alatti Telephelye" "Karcagi TK")
    ("Kádas György Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola és Kollégium Kossuth Lajos Utca 57. sz. Alatti Telephelye" "Karcagi TK")
    ("Kádas György Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola és Kollégium Zöldfa utcai Telephelye" "Karcagi TK")
    ("Karcagi Erkel Ferenc Alapfokú Mûvészeti Iskola Kálvin Utcai Telephelye" "Karcagi TK")
    ("Karcagi Kováts Mihály Általános Iskola" "Karcagi TK")
    ("Karcagi Kováts Mihály Általános Iskola Kálvin utcai telephelye" "Karcagi TK")
    ("Karcagi Kováts Mihály Általános Iskola Kiskulcsosi Általános Iskolájának telephelye" "Karcagi TK")
    ("Kunhegyesi Általános Iskola" 	"Karcagi TK")
    ("Kunhegyesi Általános Iskola Tiszagyendai Általános Iskolája" "Karcagi TK")
    ("Kunmadarasi Általános Iskola Kálvin úti telephelye" "Karcagi TK")
    ("Kunmadarasi Általános Iskola Karcagi út 6. szám alatti telephelye" "Karcagi TK")
    ("Mezõtúri Bárdos Lajos Alapfokú Mûvészeti Iskola Damjanich Utcai Telephelye" "Karcagi TK")
    ("Mezõtúri II. Rákóczi Ferenc Magyar-Angol Két Tanítási Nyelvû Általános Iskola" "Karcagi TK")
    ("Mezõtúri II. Rákóczi Ferenc Magyar-Angol Két Tanítási Nyelvû Általános Iskola Kossuth Lajos Magyar-Angol Két Tanítási Nyelvû Általános Iskolája Bajcsy-Zsilinszky utcai telephelye" "Karcagi TK")
    ("Mezõtúri II. Rákóczi Ferenc Magyar-Angol Két Tanítási Nyelvû Általános Iskola Mesterszállási Telephelye" "Karcagi TK")
    ("Tiszafüredi Kossuth Lajos Gimnázium és Általános Iskola Petõfi Utcai Telephelye" "Karcagi TK")
    ("Tiszafüredi Kossuth Lajos Gimnázium Nagyiváni Általános Iskolája" "Karcagi TK")
    ("Tiszafüredi Kossuth Lajos Gimnázium Nagyiváni Általános Iskolája Tiszaörsi Telephelye" "Karcagi TK")
    ("Tiszatenyõi Szent István Általános Iskola" "Karcagi TK")
    ("Tomajmonostorai Általános Iskola Telephelye" "Karcagi TK")
    ("Törökszentmiklósi Kodály Zoltán Alapfokú Mûvészeti Iskola Almásy Úti Telephelye" "Karcagi TK")
    ("Törökszentmiklósi Kodály Zoltán Alapfokú Mûvészeti Iskola Pozderka Úti Telephelye" "Karcagi TK")
    ("Túrkevei Petõfi Sándor Általános Iskola Kálvin utcai Telephelye" "Karcagi TK")
    ("Túrkevei Petõfi Sándor Általános Iskola Széchenyi Utcai Telephelye" "Karcagi TK")
    ("Aggteleki Általános Iskola Zádorfalvai Telephelye" "Kazincbarcikai TK")
    ("Arlói Széchenyi István Általános Iskola Rákóczi út 14/A. sz. alatti Telephelye" "Kazincbarcikai TK")
    ("Arlói Széchenyi István Általános Iskola Rákóczi út 3/C. sz. alatti Telephelye" "Kazincbarcikai TK")
    ("Berentei Általános Iskola Alacska Telephelye" "Kazincbarcikai TK")
    ("Bódvaszilasi Körzeti Általános Iskola Hidvégardói Telephelye" "Kazincbarcikai TK")
    ("Bolyky Tamás Általános Iskola" "Kazincbarcikai TK")
    ("Borsodi Általános Iskola" "Kazincbarcikai TK")
    ("Borsodsziráki Bartók Béla Általános Iskola" "Kazincbarcikai TK")
    ("Csépányi Általános Iskola Ózd, Csépányi út 133. szám alatti Telephelye" "Kazincbarcikai TK")
    ("Csillagfürt EGYMI Kurityáni Eperjesi István Tagintézménye" "Kazincbarcikai TK")
    ("Csillagfürt Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelést-Oktatást Végzõ Iskola, Kollégium és Egységes Gyógypedagógiai Módszertani Intézmény" "Kazincbarcikai TK")
    ("Farkaslyuki Általános Iskola" "Kazincbarcikai TK")
    ("Hosztják Albert Általános Iskola" "Kazincbarcikai TK")
    ("Izsó Miklós Általános Iskola" "Kazincbarcikai TK")
    ("Kazincbarcikai Kodály Zoltán Alapfokú Mûvészeti Iskola" "Kazincbarcikai TK")
    ("Kazincbarcikai Kodály Zoltán Alapfokú Mûvészeti Iskola Alacskai Telephelye" "Kazincbarcikai TK")
    ("Kazincbarcikai Kodály Zoltán Alapfokú Mûvészeti Iskola Bánrévei Telephelye" "Kazincbarcikai TK")
    ("Kazincbarcikai Kodály Zoltán Alapfokú Mûvészeti Iskola Borsodsziráki Telephelye" "Kazincbarcikai TK")
    ("Kazincbarcikai Kodály Zoltán Alapfokú Mûvészeti Iskola Felsõnyárádi Telephelye" "Kazincbarcikai TK")
    ("Kazincbarcikai Kodály Zoltán Alapfokú Mûvészeti Iskola Kazincbarcika, Árpád fejedelem tér 7/A. Telephelye" "Kazincbarcikai TK")
    ("Kazincbarcikai Kodály Zoltán Alapfokú Mûvészeti Iskola Kazincbarcika, Herbolyai út 5. Telephelye" "Kazincbarcikai TK")
    ("Kazincbarcikai Kodály Zoltán Alapfokú Mûvészeti Iskola Kazincbarcika, Pollack Mihály út 29. Telephelye" "Kazincbarcikai TK")
    ("Kazincbarcikai Kodály Zoltán Alapfokú Mûvészeti Iskola Kurityáni Telephelye" "Kazincbarcikai TK")
    ("Kazincbarcikai Kodály Zoltán Alapfokú Mûvészeti Iskola Ormosbányai Telephelye" "Kazincbarcikai TK")
    ("Kazincbarcikai Kodály Zoltán Alapfokú Mûvészeti Iskola Ragályi Telephelye" "Kazincbarcikai TK")
    ("Kazincbarcikai Kodály Zoltán Alapfokú Mûvészeti Iskola Rudolftelepi Telephelye" "Kazincbarcikai TK")
    ("Kazincbarcikai Kodály Zoltán Alapfokú Mûvészeti Iskola Sajószentpéter, Vörösmarty utca 1. Telephely" "Kazincbarcikai TK")
    ("Kazincbarcikai Kodály Zoltán Alapfokú Mûvészeti Iskola Szögligeti Telephelye" "Kazincbarcikai TK")
    ("Kazincbarcikai Kodály Zoltán Alapfokú Mûvészeti Iskola Zádorfalvai Telephelye" "Kazincbarcikai TK")
    ("Kazincbarcikai Pollack Mihály Általános Iskola" "Kazincbarcikai TK")
    ("Kazincbarcikai Pollack Mihály Általános Iskola Árpád Fejedelem Tagiskolája" "Kazincbarcikai TK")
    ("Kazincbarcikai Pollack Mihály Általános Iskola Gárdonyi Géza Tagiskolája" "Kazincbarcikai TK")
    ("Kazinczy Gábor Általános Iskola" "Kazincbarcikai TK")
    ("Lajos Árpád Általános Iskola Iskola utca 31. szám alatti Telephelye" "Kazincbarcikai TK")
    ("Nyárády András Általános Iskola" "Kazincbarcikai TK")
    ("Nyárády András Általános Iskola Kossuth Lajos Tagiskolája Rudolftelepi Telephelye" "Kazincbarcikai TK")
    ("Ózdi Apáczai Csere János Általános Iskola" "Kazincbarcikai TK")
    ("Ózdi Erkel Ferenc Alapfokú Mûvészeti Iskola" "Kazincbarcikai TK")
    ("Ózdi Erkel Ferenc Alapfokú Mûvészeti Iskola Balatoni Telephelye" "Kazincbarcikai TK")
    ("Ózdi Erkel Ferenc Alapfokú Mûvészeti Iskola Bolyky Tamás Úti Telephelye" "Kazincbarcikai TK")
    ("Ózdi Erkel Ferenc Alapfokú Mûvészeti Iskola Borsodnádasdi Telephelye" "Kazincbarcikai TK")
    ("Ózdi Erkel Ferenc Alapfokú Mûvészeti Iskola Csépányi Úti Telephelye" "Kazincbarcikai TK")
    ("Ózdi Erkel Ferenc Alapfokú Mûvészeti Iskola Mekcsey Úti Telephelye" "Kazincbarcikai TK")
    ("Ózdi Erkel Ferenc Alapfokú Mûvészeti Iskola Újváros Téri Telephelye" "Kazincbarcikai TK")
    ("Ózdi József Attila Gimnázium és Kollégium" "Kazincbarcikai TK")
    ("Péczeli József Általános Iskola és Alapfokú Mûvészeti Iskola" "Kazincbarcikai TK")
    ("Péczeli József Általános Iskola és Alapfokú Mûvészeti Iskola Serényfalvai Telephelye" "Kazincbarcikai TK")
    ("Ragályi Balassi Bálint Általános Iskola Zubogyi Telephelye" "Kazincbarcikai TK")
    ("Sajószentpéteri Kossuth Lajos Általános Iskola" "Kazincbarcikai TK")
    ("Sajószentpéteri Kossuth Lajos Általános Iskola Móra Ferenc Tagiskolája" "Kazincbarcikai TK")
    ("Sajóvárkonyi Általános Iskola Mekcsey István út 118.sz alatti Telephelye" "Kazincbarcikai TK")
    ("Serényi László Általános Iskola és Gimnázium" "Kazincbarcikai TK")
    ("Szalonnai Kalász László Általános Iskola" 	"Kazincbarcikai TK")
    ("Szendrõi Apáczai Csere János Általános Iskola" "Kazincbarcikai TK")
    ("Szendrõládi Általános Iskola" "Kazincbarcikai TK")
    ("Ujj Viktor Géza Alapfokú Mûvészeti Iskola" "Kazincbarcikai TK")
    ("Ujj Viktor Géza Alapfokú Mûvészeti Iskola Boldvai telephelye" "Kazincbarcikai TK")
    ("Ujj Viktor Géza Alapfokú Mûvészeti Iskola Szendrõládi telephelye" "Kazincbarcikai TK")
    ("Újváros Téri Általános Iskola" "Kazincbarcikai TK")
    ("Vasvár Úti Általános Iskola Tehetséggondozó Központ" "Kazincbarcikai TK")
    ("Bács-Kiskun Vármegyei  Pedagógiai Szakszolgálat Kunszentmiklósi Tagintézménye Szabadszállás Honvéd u. 28. Telephelye" "Kecskeméti TK")
    ("Bács-Kiskun Vármegyei Pedagógiai Szakszolgálat Bácsalmási Tagintézménye" "Kecskeméti TK")
    ("Bács-Kiskun Vármegyei Pedagógiai Szakszolgálat Bajai Tagintézménye" "Kecskeméti TK")
    ("Bács-Kiskun Vármegyei Pedagógiai Szakszolgálat Jánoshalmi Tagintézménye" "Kecskeméti TK")
    ("Bács-Kiskun Vármegyei Pedagógiai Szakszolgálat Kecskeméti Tagintézménye" "Kecskeméti TK")
    ("Bács-Kiskun Vármegyei Pedagógiai Szakszolgálat Kecskeméti Tagintézménye Forradalom utca 1.Telephelye" "Kecskeméti TK")
    ("Bács-Kiskun Vármegyei Pedagógiai Szakszolgálat Kiskõrösi Tagintézménye" "Kecskeméti TK")
    ("Bács-Kiskun Vármegyei Pedagógiai Szakszolgálat Kiskunfélegyházi Tagintézménye" "Kecskeméti TK")
    ("Bács-Kiskun Vármegyei Pedagógiai Szakszolgálat Kiskunmajsai Tagintézménye" "Kecskeméti TK")
    ("Bács-Kiskun Vármegyei Pedagógiai Szakszolgálat Konduktív Pedagógiai Tagintézménye" "Kecskeméti TK")
    ("Bács-Kiskun Vármegyei Pedagógiai Szakszolgálat Kunszentmiklósi Tagintézménye Dunavecse Fõ u. 39. Telephelye" "Kecskeméti TK")
    ("Bács-Kiskun Vármegyei Pedagógiai Szakszolgálat Tiszakécskei Tagintézménye" "Kecskeméti TK")
    ("Helvécia-Ballószög Általános Iskola" "Kecskeméti TK")
    ("Helvécia-Ballószög Általános Iskola Wéber Ede Általános Iskolája" "Kecskeméti TK")
    ("Jakabszállás- Fülöpjakab Általános Iskola Eötvös József Általános Iskolája" "Kecskeméti TK")
    ("Jászszentlászlói Szent László Általános Iskola" "Kecskeméti TK")
    ("Kecskeméti Belvárosi Zrínyi Ilona Általános Iskola" "Kecskeméti TK")
    ("Kecskeméti Belvárosi Zrínyi Ilona Általános Iskola Damjanich János Általános Iskolája" "Kecskeméti TK")
    ("Kecskeméti Belvárosi Zrínyi Ilona Általános Iskola Tóth László Általános Iskolája" "Kecskeméti TK")
    ("Kecskeméti Bolyai János Gimnázium" "Kecskeméti TK")
    ("Kecskeméti Corvin Mátyás Általános Iskola Hunyadi János Általános Iskolája" "Kecskeméti TK")
    ("Kecskeméti Corvin Mátyás Általános Iskola Mathiász János Általános Iskolája" "Kecskeméti TK")
    ("Kecskeméti EGYMI Autizmus Centrum Óvodája, Általános Iskolája, Készségfejlesztõ Iskolája és Fejlesztõ Nevelés-Oktatást Végzõ Iskolája" "Kecskeméti TK")
    ("Kecskeméti EGYMI Juhar Utcai Óvodája, Általános Iskolája, Készségfejlesztõ Iskolája, Fejlesztõ Nevelés-Oktatást Végzõ Iskolája és Kollégiuma" "Kecskeméti TK")
    ("Kecskeméti Katona József Gimnázium" "Kecskeméti TK")
    ("Kecskeméti Kodály Zoltán Ének-zenei Általános Iskola, Gimnázium, Szakgimnázium és Alapfokú Mûvészeti Iskola Deák Ferenc tér 1. szám alatti Telephelye" "Kecskeméti TK")
    ("Kecskeméti Kodály Zoltán Ének-zenei Általános Iskola, Gimnázium, Szakgimnázium és Alapfokú Mûvészeti Iskola Mátyás Király körút 46. szám alatti Telephelye" "Kecskeméti TK")
    ("Kecskeméti M. Bodon Pál Alapfokú Mûvészeti Iskola" "Kecskeméti TK")
    ("Kecskeméti M. Bodon Pál Alapfokú Mûvészeti Iskola Boldogasszony tér 7. szám alatti Telephelye" "Kecskeméti TK")
    ("Kecskeméti M. Bodon Pál Alapfokú Mûvészeti Iskola felsõlajosi telephelye" "Kecskeméti TK")
    ("Kecskeméti M. Bodon Pál Alapfokú Mûvészeti Iskola Hoffmann János utca 8. szám alatti Telephelye" "Kecskeméti TK")
    ("Kecskeméti M. Bodon Pál Alapfokú Mûvészeti Iskola Lánchíd utca 18. szám alatti Telephelye" "Kecskeméti TK")
    ("Kecskeméti M. Bodon Pál Alapfokú Mûvészeti Iskola Mészöly Gyula tér 1-3. szám alatti Telephelye" "Kecskeméti TK")
    ("Kecskeméti M. Bodon Pál Alapfokú Mûvészeti Iskola Piaristák tere 5. szám alatti Telephelye" "Kecskeméti TK")
    ("Kecskeméti M. Bodon Pál Alapfokú Mûvészeti Iskola Szent Imre utca 9. szám alatti Telephelye" "Kecskeméti TK")
    ("Kecskeméti Németh László Általános Iskola és Gimnázium" "Kecskeméti TK")
    ("Kecskeméti Óvoda, Általános Iskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelés-Oktatást Végzõ Iskola, Kollégium, Egységes Gyógypedagógiai Módszertani Intézmény" 	"Kecskeméti TK")
    ("Kecskeméti Széchenyivárosi Arany János Általános Iskola Móra Ferenc Általános Iskolája" "Kecskeméti TK")
    ("Kecskeméti Vásárhelyi Pál Általános Iskola és Alapfokú Mûvészeti Iskola" "Kecskeméti TK")
    ("Kecskeméti Vásárhelyi Pál Általános Iskola és Alapfokú Mûvészeti Iskola Móricz Zsigmond Általános Iskolája" "Kecskeméti TK")
    ("Kerekegyházi Móra Ferenc Általános Iskola és Alapfokú Mûvészeti Iskola" "Kecskeméti TK")
    ("Kiskunfélegyházi Balázs Árpád Alapfokú Mûvészeti Iskola - Batthyány Lajos utca 12-18. szám alatti telephelye" "Kecskeméti TK")
    ("Kiskunfélegyházi Balázs Árpád Alapfokú Mûvészeti Iskola - Dózsa György utca 26-32. szám alatti telephelye" "Kecskeméti TK")
    ("Kiskunfélegyházi Balázs Árpád Alapfokú Mûvészeti Iskola - Platán utca 12. szám alatti telephelye" "Kecskeméti TK")
    ("Kiskunfélegyházi Darvas Általános Iskola" "Kecskeméti TK")
    ("Kiskunfélegyházi Göllesz Viktor Óvoda, Általános Iskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelés-Oktatást Végzõ Iskola, Egységes Gyógypedagógiai Módszertani Intézmény" "Kecskeméti TK")
    ("Kiskunfélegyházi József Attila Sportiskolai Általános Iskola" "Kecskeméti TK")
    ("Kiskunfélegyházi Móra Ferenc Gimnázium Bajai Telephelye" "Kecskeméti TK")
    ("Kiskunfélegyházi Móra Ferenc Gimnázium Budapest Üllõi úti telephelye" "Kecskeméti TK")
    ("Kiskunfélegyházi Móra Ferenc Gimnázium Dunaújvárosi telephelye" "Kecskeméti TK")
    ("Kiskunfélegyházi Móra Ferenc Gimnázium Kistarcsai Telephelye" "Kecskeméti TK")
    ("Kiskunfélegyházi Móra Ferenc Gimnázium Székesfehérvár Seregélyesi úti Telephelye" "Kecskeméti TK")
    ("Kiskunfélegyházi Platán Utcai Általános Iskola" "Kecskeméti TK")
    ("Kiskunmajsai Arany János Általános Iskola Iskola utcai telephelye" "Kecskeméti TK")
    ("Kiskunmajsai Egressy Béni Alapfokú Mûvészeti Iskola" "Kecskeméti TK")
    ("Kiskunmajsai Egressy Béni Alapfokú Mûvészeti Iskola Jászszentlászlói Telephelye" "Kecskeméti TK")
    ("Kunszállási Tóth Pál Általános Iskola" "Kecskeméti TK")
    ("Lajosmizsei Fekete István Sportiskolai Általános Iskola" "Kecskeméti TK")
    ("Lajosmizsei Fekete István Sportiskolai Általános Iskola Felsõlajosi Tagintézménye" "Kecskeméti TK")
    ("Lakiteleki Eötvös Loránd Általános Iskola és Alapfokú Mûvészeti Iskola" "Kecskeméti TK")
    ("Móricz Zsigmond Általános Iskola és Gimnázium Alapfokú Mûvészeti Iskolája" "Kecskeméti TK")
    ("Móricz Zsigmond Általános Iskola és Gimnázium Eltérõ Tantervû Tagiskolája" "Kecskeméti TK")
    ("Móricz Zsigmond Általános Iskola és Gimnázium Tiszabögi Tagiskola Telephelye" "Kecskeméti TK")
    ("Móricz Zsigmond Általános Iskola és Gimnázium Tornaterem Telephelye" "Kecskeméti TK")
    ("Petõfiszállási Petõfi Sándor Általános Iskola" "Kecskeméti TK")
    ("Szentkirályi Általános Iskola és Alapfokú Mûvészeti Iskola" "Kecskeméti TK")
    ("Tiszakécskei Móricz Zsigmond Általános Iskola, Gimnázium, Kollégium és Alapfokú Mûvészeti Iskola" "Kecskeméti TK")
    ("Budapest X. Kerületi Zrínyi Miklós Gimnázium" "Kelet-Pesti TK")
    ("Budapest XVII. Bartók Béla Alapfokú Mûvészeti Iskola Diadal Úti telephelye" "Kelet-Pesti TK")
    ("Budapest XVII. Bartók Béla Alapfokú Mûvészeti Iskola Hõsök terei telephelye" "Kelet-Pesti TK")
    ("Budapest XVII. Bartók Béla Alapfokú Mûvészeti Iskola Liget sori telephelye" "Kelet-Pesti TK")
    ("Budapest XVII. Bartók Béla Alapfokú Mûvészeti Iskola Szabadság Sugárúti telephelye" "Kelet-Pesti TK")
    ("Budapest XVII. Bartók Béla Alapfokú Mûvészeti Iskola Újlak utcai telephelye" "Kelet-Pesti TK")
    ("Budapest XVII. Kerületi Bartók Béla Alapfokú Mûvészeti Iskola" "Kelet-Pesti TK")
    ("Budapest XVII. Kerületi Czimra Gyula Általános Iskola Kép utca 1. Alatti Telephelye" "Kelet-Pesti TK")
    ("Budapest XVII. Kerületi Czimra Gyula Általános Iskola Kép utca 2. Alatti Telephelye" "Kelet-Pesti TK")
    ("Budapest XVII. Kerületi Czimra Gyula Általános Iskola Kép utca 5. Alatti Telephelye" "Kelet-Pesti TK")
    ("Budapest XVII. Kerületi Kossuth Lajos Általános Iskola" "Kelet-Pesti TK")
    ("Budapest XVII. Kerületi Zrínyi Miklós Általános Iskola" "Kelet-Pesti TK")
    ("Gyurkovics Tibor Óvoda, Általános Iskola és Egységes Gyógypedagógiai Módszertani Intézmény" "Kelet-Pesti TK")
    ("Gyurkovics Tibor Óvoda, Általános Iskola és Egységes Gyógypedagógiai Módszertani Intézmény Peregi Úti Telephelye (007" "	Kelet-Pesti TK")
    ("Kõbányai Csukás István Magyar-Angol Két Tanítási Nyelvû Általános Iskola" "Kelet-Pesti TK")
    ("Kõbányai Harmat Általános Iskola" "Kelet-Pesti TK")
    ("Kõbányai Kada Mihály Általános Iskola" "Kelet-Pesti TK")
    ("Kõbányai Kertvárosi Általános Iskola" "Kelet-Pesti TK")
    ("Kõbányai Komplex Óvoda, Általános Iskola, Készségfejlesztõ Iskola és Egységes Gyógypedagógiai Módszertani Intézmény Telephelye" "Kelet-Pesti TK")
    ("Kõbányai Szent László Általános Iskola" "Kelet-Pesti TK")
    ("Kõbányai Szervátiusz Jenõ Általános Iskola" "Kelet-Pesti TK")
    ("Kroó György Zene- és Képzõmûvészeti Kõbányai Alapfokú Mûvészeti Iskola Harmat utca 196-198. Alatti Telephelye" "Kelet-Pesti TK")
    ("Kroó György Zene- és Képzõmûvészeti Kõbányai Alapfokú Mûvészeti Iskola Hungária körút 5-7. Alatti Telephelye" "Kelet-Pesti TK")
    ("Kroó György Zene- és Képzõmûvészeti Kõbányai Alapfokú Mûvészeti Iskola Kada utca 27-29. Alatti Telephelye" "Kelet-Pesti TK")
    ("Kroó György Zene- és Képzõmûvészeti Kõbányai Alapfokú Mûvészeti Iskola Keresztúri út 7-9. Alatti Telephelye" "Kelet-Pesti TK")
    ("Kroó György Zene- és Képzõmûvészeti Kõbányai Alapfokú Mûvészeti Iskola Újhegyi sétány 1-3. Alatti Telephelye" "Kelet-Pesti TK")
    ("Szabadság Sugárúti Általános Iskola" "Kelet-Pesti TK")
    ("Szabadság Sugárúti Általános Iskola Szabadság sugárút 34-36. Telephelye" "Kelet-Pesti TK")
    (" Tassi Földváry Gábor Magyar-Német Két Tanítási Nyelvû Általános Iskola Dunai út 1. alatti telephelye" "Kiskõrösi TK")
    ("Apostagi Nagy Lajos Általános Iskola Bajcsy-Zsilinszky utca 3. szám alatti Telephelye" "Kiskõrösi TK")
    ("Apostagi Nagy Lajos Általános Iskola Hunyadi utca 18. szám alatti Telephelye" "Kiskõrösi TK")
    ("Bócsai Boróka Általános Iskola" "Kiskõrösi TK")
    ("Duna Menti Egységes Gyógypedagógiai Módszertani Intézmény, Általános Iskola, Szakiskola és Kollégium 005-ös Telephely" "Kiskõrösi TK")
    ("Dunaegyházi Szlovák Nemzetiségi Általános Iskola" "Kiskõrösi TK")
    ("Dunavecsei Petõfi Sándor Általános Iskola Hõsök Terei Telephelye" "Kiskõrösi TK")
    ("Izsáki Táncsics Mihály Általános Iskola" "Kiskõrösi TK")
    ("Jánoshalmi Hunyadi János Általános Iskola" 	"Kiskõrösi TK")
    ("Kelebiai Farkas László Általános Iskola" "Kiskõrösi TK")
    ("Kiskõrösi Bem József Általános Iskola Csengõdi Általános Iskolája" "Kiskõrösi TK")
    ("Kiskõrösi Bem József Általános Iskola Herpai Vilmos Általános Iskolája Telephelye" "Kiskõrösi TK")
    ("Kiskõrösi Bem József Általános Iskola Páhi Általános Iskolája" "Kiskõrösi TK")
    ("Kiskõrösi Bem József Általános Iskola Páhi Általános Iskolájának Vasút utca 6. szám Alatti Telephelye" "Kiskõrösi TK")
    ("Kiskõrösi Bem József Általános Iskola Tabdi Telephelye" "Kiskõrösi TK")
    ("Kiskõrösi Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda,Általános Iskola és Készségfejlesztõ Iskola Telephelye" "Kiskõrösi TK")
    ("Kiskõrösi SZÓ-LA-M Alapfokú Mûvészeti Iskola Izsáki telephely" "Kiskõrösi TK")
    ("Kiskõrösi SZÓ-LA-M Alapfokú Mûvészeti Iskola Kiskõrösi telephely" "Kiskõrösi TK")
    ("Kiskunhalasi Alapfokú Mûvészeti Iskola Fazekas Utcai Telephelye" "Kiskõrösi TK")
    ("Kiskunhalasi Alapfokú Mûvészeti Iskola Kisszállási Telephelye" "Kiskõrösi TK")
    ("Kiskunhalasi Alapfokú Mûvészeti Iskola Nyírfa Utcai telephelye" "Kiskõrösi TK")
    ("Kiskunhalasi Alapfokú Mûvészeti Iskola Tompai Telephelye" "Kiskõrösi TK")
    ("Kiskunhalasi Bernáth Lajos Kollégium" "Kiskõrösi TK")
    ("Kiskunhalasi Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda és Általános Iskola" "Kiskõrösi TK")
    ("Kiskunhalasi Fazekas Mihály Általános Iskola Balotaszállási Tagintézménye" "Kiskõrösi TK")
    ("Kiskunhalasi Felsõvárosi Általános Iskola" "Kiskõrösi TK")
    ("Kiskunhalasi Felsõvárosi Általános Iskola Szabadság Téri Telephelye" "Kiskõrösi TK")
    ("Kiskunhalasi Konduktív Óvoda és Általános Iskola" 	"Kiskõrösi TK")
    ("Kisszállási Sallai István Általános Iskola Telephelye" "Kiskõrösi TK")
    ("Kunpeszéri Általános Iskola" "Kiskõrösi TK")
    ("Kunszentmiklósi Szappanos Lukács Alapfokú Mûvészeti Iskola Apostagi Telephely" "Kiskõrösi TK")
    ("Kunszentmiklósi Szappanos Lukács Alapfokú Mûvészeti Iskola Dunavecsei Telephely" "Kiskõrösi TK")
    ("Kunszentmiklósi Szappanos Lukács Alapfokú Mûvészeti Iskola Szabadszállási Telephely" "Kiskõrösi TK")
    ("Kunszentmiklósi Szappanos Lukács Alapfokú Mûvészeti Iskola Tassi Telephely" "Kiskõrösi TK")
    ("Rémi Általános Iskola" "Kiskõrösi TK")
    ("Szabadszállási Petõfi Sándor Általános Iskola" "Kiskõrösi TK")
    ("Szabadszállási Petõfi Sándor Általános Iskola Rákóczi Téri Telephelye" "Kiskõrösi TK")
    ("Tassi Földváry Gábor Magyar-Német Két Tanítási Nyelvû Általános Iskola" "Kiskõrösi TK")
    ("Tompai Szabó Dénes Általános Iskola Telephelye (002" 	"Kiskõrösi TK")
    ("Aranyosapáti Általános Iskola" "Kisvárdai TK")
    ("Babus Jolán Középiskolai Kollégium" "Kisvárdai TK")
    ("Baktalórántházi Reguly Antal Általános Iskola Baktalórántházai Telephelye" "Kisvárdai TK")
    ("Baktalórántházi Reguly Antal Általános Iskola Ófehértói Telephelye" "Kisvárdai TK")
    ("Bónis Sámuel Általános Iskola" "Kisvárdai TK")
    ("Csarodai Herman Ottó Általános Iskola Beregsurányi Tagintézménye" "Kisvárdai TK")
    ("DOC Gimnázium és Általános Iskola Berkeszi Tagintézménye" "Kisvárdai TK")
    ("DOC Gimnázium és Általános Iskola Demecseri Általános Iskolája Alapfokú Mûvészeti Iskolája Dombrádi Telephelye" "Kisvárdai TK")
    ("DOC Gimnázium és Általános Iskola Demecseri Általános Iskolája Alapfokú Mûvészeti Iskolája Újdombrádi Telephelye" "Kisvárdai TK")
    ("DOC Gimnázium és Általános Iskola Demecseri Általános Iskolája, Alapfokú Mûvészeti Iskolája" "Kisvárdai TK")
    ("DOC Gimnázium és Általános Iskola Demecseri Általános Iskolája, Alapfokú Mûvészeti Iskolája Besztereci Telephelye" "Kisvárdai TK")
    ("DOC Gimnázium és Általános Iskola Demecseri Általános Iskolája, Alapfokú Mûvészeti Iskolája Nyírjákói Telephelye" "Kisvárdai TK")
    ("Dombrádi Móra Ferenc Általános Iskola, Gimnázium és Alapfokú Mûvészeti Iskola" "Kisvárdai TK")
    ("Dr. Kozma Pál Általános Iskola" "Kisvárdai TK")
    ("Dr. Udvari István Általános Iskola" "Kisvárdai TK")
    ("Fényeslitkei Kossuth Lajos Általános Iskola Petõfi Sándor Tagiskolája" "Kisvárdai TK")
    ("Gyürei Általános Iskola, Gimnázium, Alapfokú Mûvészeti Iskola" "Kisvárdai TK")
    ("Gyürei Általános Iskola, Gimnázium, Alapfokú Mûvészeti Iskola Gemzsei Tagintézménye" "Kisvárdai TK")
    ("Gyürei Általános Iskola, Gimnázium, Alapfokú Mûvészeti Iskola I. László Király Tagintézménye" 	"Kisvárdai TK")
    ("Kékcsei Arany János Általános Iskola" 	"Kisvárdai TK")
    ("Kisvárdai Bessenyei György Gimnázium és Kollégium" "Kisvárdai TK")
    ("Kisvárdai Bessenyei György Gimnázium és Kollégium 003-as Telephelye" "Kisvárdai TK")
    ("Kisvárdai Weiner Leó Alapfokú Mûvészeti Iskola Ajaki Telephelye" "Kisvárdai TK")
    ("Kisvárdai Weiner Leó Alapfokú Mûvészeti Iskola Gégényi Telephelye" "Kisvárdai TK")
    ("Kisvárdai Weiner Leó Alapfokú Mûvészeti Iskola Mártírok útjai Telephelye" "Kisvárdai TK")
    ("Kisvárdai Weiner Leó Alapfokú Mûvészeti Iskola Nap utcai Telephelye" "Kisvárdai TK")
    ("Kisvárdai Weiner Leó Alapfokú Mûvészeti Iskola Tiszakanyári Telephelye" "Kisvárdai TK")
    ("Leveleki Gárdonyi Géza Általános Iskola" "Kisvárdai TK")
    ("Lónyay Menyhért Általános Iskola" "Kisvárdai TK")
    ("Nyárády Mihály Általános Iskola" "Kisvárdai TK")
    ("Nyírkarászi Váci Mihály Általános Iskola" "Kisvárdai TK")
    ("Ölbey Irén Általános Iskola" "Kisvárdai TK")
    ("Patay István Általános Iskola" "Kisvárdai TK")
    ("Patay István Általános Iskola 2. Telephelye" "Kisvárdai TK")
    ("Petneházy Dávid Általános Iskola és Alapfokú Mûvészeti Iskola" "Kisvárdai TK")
    ("Sennyey Elza Általános Iskola" "Kisvárdai TK")
    ("Szabolcsveresmarti Kazinczy Ferenc Általános Iskola" "Kisvárdai TK")
    ("Tarpai Esze Tamás Általános Iskola" "Kisvárdai TK")
    ("Teichmann Vilmos Általános Iskola" "Kisvárdai TK")
    ("Tiszakanyári Hunyadi Mátyás Általános Iskola Újdombrádi Tagintézménye" "Kisvárdai TK")
    ("Tornyospálcai Általános Iskola és Alapfokú Mûvészeti Iskola Bethlen Gábor Tagintézménye" "Kisvárdai TK")
    ("Tornyospálcai Általános Iskola és Alapfokú Mûvészeti Iskola Mezõladányi Tagintézménye" "Kisvárdai TK")
    ("Vári Emil Általános Iskola" "Kisvárdai TK")
    ("Vári Emil Általános Iskola Kossuth Lajos Tagintézménye" "Kisvárdai TK")
    ("Vásárosnaményi Eötvös József Általános Iskola és Alapfokú Mûvészeti Iskola Csarodai Telephelye" "Kisvárdai TK")
    ("Vásárosnaményi Eötvös József Általános Iskola és Alapfokú Mûvészeti Iskola Petõfi Sándor Tagintézménye" "Kisvárdai TK")
    ("Vasmegyeri Megyer Vezér Általános Iskola" "Kisvárdai TK")
    ("Záhonyi Árpád Vezér Általános Iskola és Alapfokú Mûvészeti Iskola" "Kisvárdai TK")
    ("Áldás Utcai Általános Iskola" "Közép-Budai TK")
    ("Budapest I. Kerületi Farkas Ferenc Zenei Alapfokú Mûvészeti Iskola" "Közép-Budai TK")
    ("Budapest I. Kerületi Farkas Ferenc Zenei Alapfokú Mûvészeti Iskola Batthyány Utcai Telephelye" "Közép-Budai TK")
    ("Budapest I. Kerületi Farkas Ferenc Zenei Alapfokú Mûvészeti Iskola Tárnok Utcai Telephelye" "Közép-Budai TK")
    ("Budapest I. Kerületi Petõfi Sándor Gimnázium" "Közép-Budai TK")
    ("Budapest I. Kerületi Toldy Ferenc Gimnázium" "Közép-Budai TK")
    ("Budapest II. Kerületi II. Rákóczi Ferenc Gimnázium" "Közép-Budai TK")
    ("Budapest II. Kerületi Pitypang Utcai Általános Iskola" "Közép-Budai TK")
    ("Budenz József Általános Iskola és Gimnázium" "Közép-Budai TK")
    ("Fekete István Óvoda, Általános Iskola, Szakiskola és Egységes Gyógypedagógiai Módszertani Intézmény" "Közép-Budai TK")
    ("Fekete István Óvoda, Általános Iskola, Szakiskola és Egységes Gyógypedagógiai Módszertani Intézmény Fajd utcai Telephelye" "Közép-Budai TK")
    ("Gennaro Verolino Óvoda, Általános Iskola, Készségfejlesztõ Iskola és Kollégium" "Közép-Budai TK")
    ("Járdányi Pál Zeneiskola Alapfokú Mûvészeti Iskola" "Közép-Budai TK")
    ("Járdányi Pál Zeneiskola Alapfokú Mûvészeti Iskola Áldás utca 1. Telephelye" "Közép-Budai TK")
    ("Járdányi Pál Zeneiskola Alapfokú Mûvészeti Iskola Fenyves utca 1. Telephelye" "Közép-Budai TK")
    ("Járdányi Pál Zeneiskola Alapfokú Mûvészeti Iskola Községház utca 10. Telephelye" "Közép-Budai TK")
    ("Járdányi Pál Zeneiskola Alapfokú Mûvészeti Iskola Máriaremetei út 71. Telephelye" "Közép-Budai TK")
    ("Járdányi Pál Zeneiskola Alapfokú Mûvészeti Iskola Pasaréti út 191-193. Telephelye" "Közép-Budai TK")
    ("Járdányi Pál Zeneiskola Alapfokú Mûvészeti Iskola Szabadság utca 23. Telephelye" "Közép-Budai TK")
    ("Járdányi Pál Zeneiskola Alapfokú Mûvészeti Iskola Ürömi út 64. Telephelye" "Közép-Budai TK")
    ("Káldor Miklós Kollégium" "Közép-Budai TK")
    ("Káldor Miklós Kollégium Donát utca 46. telephelye" "Közép-Budai TK")
    ("Kodály Zoltán Ének-zenei Általános Iskola, Gimnázium és Zenei Alapfokú Mûvészeti Iskola" "Közép-Budai TK")
    ("Németvölgyi Általános Iskola" "Közép-Budai TK")
    ("Palotás Gábor Általános Iskola" "Közép-Budai TK")
    ("Pasaréti Szabó Lõrinc Magyar-Angol Két Tanítási Nyelvû Általános Iskola és Gimnázium Fenyves utca 1. Telephelye" "Közép-Budai TK")
    ("Rózsadombi Általános Iskola" "Közép-Budai TK")
    ("Solti György Zenei Alapfokú Mûvészeti Iskola" "Közép-Budai TK")
    ("Solti György Zenei Alapfokú Mûvészeti Iskola Diana út 35-37. telephelye" "Közép-Budai TK")
    ("Solti György Zenei Alapfokú Mûvészeti Iskola Kiss János altb. utca 42-44. telephelye" "Közép-Budai TK")
    ("Solti György Zenei Alapfokú Mûvészeti Iskola Meredek u. 1. telephelye" "Közép-Budai TK")
    ("Solti György Zenei Alapfokú Mûvészeti Iskola Városmajor u. 59 telephelye" "Közép-Budai TK")
    ("Solti György Zenei Alapfokú Mûvészeti Iskola Virányos út 48. telephelye" "Közép-Budai TK")
    ("Svábhegyi Jókai Mór Általános Iskola és Német Nemzetiségi Általános Iskola" "Közép-Budai TK")
    ("Tapolcsányi Általános Iskolai és Középiskolai Kollégium" "Közép-Budai TK")
    ("Városmajori Gimnázium" "Közép-Budai TK")
    ("Virányos Általános Iskola" "Közép-Budai TK")
    ("Zugligeti Általános Iskola Telephelye" "Közép-Budai TK")
    ("Álmos Vezér Gimnázium, Pedagógiai Szakgimnázium és Általános Iskola" "Közép-Pesti TK")
    ("Berzsenyi Dániel Gimnázium" "Közép-Pesti TK")
    ("Budapest XIII. Kerületi Csata Utcai Általános Iskola" "Közép-Pesti TK")
    ("Budapest XIII. Kerületi Eötvös József Általános Iskola" "	Közép-Pesti TK")
    ("Budapest XIII. Kerületi Fischer Annie Zeneiskola-Alapfokú Mûvészeti Iskola Csata u. 20 alatti telephelye" "Közép-Pesti TK")
    ("Budapest XIII. Kerületi Fischer Annie Zeneiskola-Alapfokú Mûvészeti Iskola Fiastyúk utca 47-49. alatti telephelye" "Közép-Pesti TK")
    ("Budapest XIII. Kerületi Fischer Annie Zeneiskola-Alapfokú Mûvészeti Iskola Gyöngyösi sétány 7. alatti telephelye" "Közép-Pesti TK")
    ("Budapest XIII. Kerületi Fischer Annie Zeneiskola-Alapfokú Mûvészeti Iskola Radnóti M. utca 35. alatti telephelye" "Közép-Pesti TK")
    ("Budapest XIII. Kerületi Fischer Annie Zeneiskola-Alapfokú Mûvészeti Iskola Tomori utca 2. alatti telephelye" "Közép-Pesti TK")
    ("Budapest XIII. Kerületi Fischer Annie Zeneiskola-Alapfokú Mûvészeti Iskola Vizafogó sétány 2. alatti telephelye" "Közép-Pesti TK")
    ("Budapest XIII. Kerületi Hegedüs Géza Általános Iskola" "Közép-Pesti TK")
    ("Budapest XIII. Kerületi Hunyadi Mátyás Általános Iskola" "Közép-Pesti TK")
    ("Budapest XIII. Kerületi Számítástechnikai Általános Iskola" "Közép-Pesti TK")
    ("Budapest XIII. Kerületi Vizafogó Általános Iskola" "Közép-Pesti TK")
    ("Budapest XIV. Kerületi Kaffka Margit Általános Iskola" "	Közép-Pesti TK")
    ("Budapest XIV. Kerületi Móra Ferenc Általános Iskola" "Közép-Pesti TK")
    ("Budapest XIV. Kerületi Széchenyi István Általános Iskola" "Közép-Pesti TK")
    ("Budapesti Egyesített Középiskolai Kollégium" "Közép-Pesti TK")
    ("Budapesti Egyesített Középiskolai Kollégium 3. sz. Telephelye" "Közép-Pesti TK")
    ("Deák Ferenc Középiskolai Kollégium" "Közép-Pesti TK")
    ("Dr. Török Béla Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelés-Oktatást Végzõ Iskola és Kollégium" "Közép-Pesti TK")
    ("Dr. Török Béla Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelés-Oktatást Végzõ Iskola és Kollégium Újváros park" "Közép-Pesti TK")
    ("Fõvárosi Pedagógiai Szakszolgálat (Izabella utca 1. Telephelye" "Közép-Pesti TK")
    ("Fõvárosi Pedagógiai Szakszolgálat Beszédjavító, Gyógypedagógiai Tanácsadó, Korai Fejlesztõ, Oktató és Gondozó Tagintézménye" "Közép-Pesti TK")
    ("Fõvárosi Pedagógiai Szakszolgálat II. Kerületi Tagintézménye" "Közép-Pesti TK")
    ("Fõvárosi Pedagógiai Szakszolgálat III. Kerületi Tagintézménye (Bebó Károly utca 13. Telephelye" "	Közép-Pesti TK")
    ("Fõvárosi Pedagógiai Szakszolgálat III. Kerületi Tagintézménye (Víziorgona utca 7. Telephelye" "	Közép-Pesti TK")
    ("Fõvárosi Pedagógiai Szakszolgálat IX. Kerületi Tagintézménye" "Közép-Pesti TK")
    ("Fõvárosi Pedagógiai Szakszolgálat V. Kerületi Tagintézménye" "Közép-Pesti TK")
    ("Fõvárosi Pedagógiai Szakszolgálat VI. Kerületi Tagintézménye (Nagymezõ utca 52. Telephelye" "	Közép-Pesti TK")
    ("Fõvárosi Pedagógiai Szakszolgálat VIII. Kerületi Tagintézménye" "Közép-Pesti TK")
    ("Fõvárosi Pedagógiai Szakszolgálat XI. Kerületi Tagintézménye" "Közép-Pesti TK")
    ("Fõvárosi Pedagógiai Szakszolgálat XI. Kerületi Tagintézménye (Rétköz utca 14. Telephelye" "	Közép-Pesti TK")
    ("Fõvárosi Pedagógiai Szakszolgálat XIII. Kerületi Tagintézménye" "Közép-Pesti TK")
    ("Fõvárosi Pedagógiai Szakszolgálat XIV. Kerületi Tagintézménye" "Közép-Pesti TK")
    ("Fõvárosi Pedagógiai Szakszolgálat XIX. Kerületi Tagintézménye" "Közép-Pesti TK")
    ("Fõvárosi Pedagógiai Szakszolgálat XV. Kerületi Tagintézménye" "Közép-Pesti TK")
    ("Fõvárosi Pedagógiai Szakszolgálat XVII. Kerületi Tagintézménye" "Közép-Pesti TK")
    ("Fõvárosi Pedagógiai Szakszolgálat XVIII. Kerületi Tagintézménye" "Közép-Pesti TK")
    ("Fõvárosi Pedagógiai Szakszolgálat XX. Kerületi Tagintézménye" "Közép-Pesti TK")
    ("Fõvárosi Pedagógiai Szakszolgálat XXI. Kerületi Tagintézménye" "Közép-Pesti TK")
    ("Fõvárosi Pedagógiai Szakszolgálat XXIII. Kerületi Tagintézménye" "Közép-Pesti TK")
    ("Hallássérültek Óvodája, Általános Iskolája, Szakiskolája, Egységes Gyógypedagógiai Módszertani Intézménye és Kollégiuma" "	Közép-Pesti TK")
    ("Hunyadi János Ének-zenei, Nyelvi Általános Iskola" "Közép-Pesti TK")
    ("Középiskolai Leánykollégium" "	Közép-Pesti TK")
    ("Németh László Gimnázium" "Közép-Pesti TK")
    ("Prizma Általános Iskola és Óvoda, Egységes Gyógypedagógiai Módszertani Intézmény" "Közép-Pesti TK")
    ("Prizma Általános Iskola és Óvoda, Egységes Gyógypedagógiai Módszertani Intézmény Lomb Utcai Telephelye" "Közép-Pesti TK")
    ("Szent István Király Zenemûvészeti Szakgimnázium és Alapfokú Mûvészeti Iskola" "Közép-Pesti TK")
    ("Szent István Király Zenemûvészeti Szakgimnázium és Alapfokú Mûvészeti Iskola 1144 Budapest, Kántorné sétány7. Telephelye" "Közép-Pesti TK")
    ("Szent István Király Zenemûvészeti Szakgimnázium és Alapfokú Mûvészeti Iskola 1144 Budapest, Telepes utca 32. Telephelye" "Közép-Pesti TK")
    ("Szent István Király Zenemûvészeti Szakgimnázium és Alapfokú Mûvészeti Iskola 1145 Budapest, Erzsébet királyné útja 35-37. Telephelye" "Közép-Pesti TK")
    ("Szent István Király Zenemûvészeti Szakgimnázium és Alapfokú Mûvészeti Iskola 1146 Budapest, Ajtósi Dürer sor 15. Telephelye" "Közép-Pesti TK")
    ("Szent István Király Zenemûvészeti Szakgimnázium és Alapfokú Mûvészeti Iskola 1146 Budapest, Cházár András utca 10. Telephelye" "Közép-Pesti TK")
    ("Szent István Király Zenemûvészeti Szakgimnázium és Alapfokú Mûvészeti Iskola 1148 Budapest, Hermina út 23. Telephelye" "Közép-Pesti TK")
    ("Szent István Király Zenemûvészeti Szakgimnázium és Alapfokú Mûvészeti Iskola 1148 Budapest, Lengyel utca 23. Telephelye" "Közép-Pesti TK")
    ("Szent István Király Zenemûvészeti Szakgimnázium és Alapfokú Mûvészeti Iskola 1149 Budapest, Egressy út 69. Telephelye" "Közép-Pesti TK")
    ("Vakok Egységes Gyógypedagógiai Módszertani Intézménye, Óvodája, Általános Iskolája, Szakiskolája, Készségfejlesztõ Iskolája,  Fejlesztõ Nevelés-Oktatást Végzõ Iskolája, Kollégiuma és Gyermekotthona" "Közép-Pesti TK")
    ("Városligeti Magyar-Angol Két Tanítási Nyelvû Általános Iskola" "Közép-Pesti TK")
    ("Zuglói Benedek Elek Óvoda, Általános Iskola, Egységes Gyógypedagógiai Módszertani Intézmény" "Közép-Pesti TK")
    ("Zuglói Hajós Alfréd Magyar-Német Két Tanítási Nyelvû Általános Iskola" "Közép-Pesti TK")
    ("Zuglói Herman Ottó Tudásközpont Általános Iskola" "Közép-Pesti TK")
    ("Benedek Elek Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Készségfejlesztõ Iskola és Szakiskola" "Külsõ-Pesti TK")
    ("Budapest XVIII. Kerületi Bókay Árpád Általános Iskola" "Külsõ-Pesti TK")
    ("Budapest XVIII. Kerületi Kondor Béla Általános Iskola" "Külsõ-Pesti TK")
    ("Budapest XVIII. Kerületi Táncsics Német Nemzetiségi Általános Iskola" "Külsõ-Pesti TK")
    ("Budapest XVIII. Kerületi Vörösmarty Mihály Ének-zenei, Nyelvi Általános Iskola és Gimnázium Telephelye" "Külsõ-Pesti TK")
    ("Budapest XX. Kerületi Hajós Alfréd Általános Iskola" "Külsõ-Pesti TK")
    ("Budapest XX. Kerületi Lajtha László Alapfokú Mûvészeti Iskola" "Külsõ-Pesti TK")
    ("Budapest XX. Kerületi Lajtha László Alapfokú Mûvészeti Iskola- Attila utcai Telephelye" "Külsõ-Pesti TK")
    ("Budapest XX. Kerületi Lajtha László Alapfokú Mûvészeti Iskola- Mártírok útja 205. Telephelye" "Külsõ-Pesti TK")
    ("Budapest XX. Kerületi Nagy László Általános Iskola és Gimnázium" "Külsõ-Pesti TK")
    ("Budapest, XVIII. Kerületi Bókay Árpád Általános Iskola Szélmalom u. 51.Alatti Telephelye" "Külsõ-Pesti TK")
    ("Budapest, XVIII. kerületi SOFI Óvoda, Általános Iskola, Speciális Szakiskola és Egységes Gyógypedagógiai Módszertani Intézmény Kondor Béla sétány 15. Telephelye" "Külsõ-Pesti TK")
    ("Dohnányi Ernõ Alapfokú Mûvészeti Iskola" "Külsõ-Pesti TK")
    ("Dohnányi Ernõ Alapfokú Mûvészeti Iskola Darus Utcai Általános és Magyar-Német Kéttannyelvû Iskola Telephelye" "Külsõ-Pesti TK")
    ("Dohnányi Ernõ Alapfokú Mûvészeti Iskola Gyöngyvirág utca 41. Telephelye" "Külsõ-Pesti TK")
    ("Dohnányi Ernõ Alapfokú Mûvészeti Iskola Kapocs utcai Telephelye" "Külsõ-Pesti TK")
    ("Dohnányi Ernõ Alapfokú Mûvészeti Iskola Kassa Utcai Általános Iskola Telephelye" "Külsõ-Pesti TK")
    ("Dohnányi Ernõ Alapfokú Mûvészeti Iskola Kossuth Lajos téri Telephelye" "Külsõ-Pesti TK")
    ("Dohnányi Ernõ Alapfokú Mûvészeti Iskola Nemes utcai Telephelye" "Külsõ-Pesti TK")
    ("Dohnányi Ernõ Alapfokú Mûvészeti Iskola Üllõi úti Telephelye" "Külsõ-Pesti TK")
    ("Dohnányi Ernõ Alapfokú Mûvészeti Iskola Vörösmarty Mihály utcai Telephelye" "Külsõ-Pesti TK")
    ("Eötvös Loránd Általános Iskola és Magyar-Angol Két Tanítási Nyelvû Általános Iskola" "Külsõ-Pesti TK")
    ("Gulner Gyula Általános Iskola" "Külsõ-Pesti TK")
    ("Hungária Általános Iskola és Kollégium" "Külsõ-Pesti TK")
    ("Kandó Téri Általános Iskola Háromszéki utcai Telephelye" "Külsõ-Pesti TK")
    ("Karinthy Frigyes Gimnázium" "Külsõ-Pesti TK")
    ("Kassa Utcai Általános Iskola" "Külsõ-Pesti TK")
    ("Kisfaludy Károly Középiskolai Kollégium" "Külsõ-Pesti TK")
    ("Kispesti Alapfokú Mûvészeti Iskola Eötvös Utcai Telephelye" "Külsõ-Pesti TK")
    ("Kispesti Alapfokú Mûvészeti Iskola Nádasdy Utcai Telephelye" "Külsõ-Pesti TK")
    ("Kispesti Bolyai János Általános Iskola" "Külsõ-Pesti TK")
    ("Kispesti Eötvös József Általános Iskola" "Külsõ-Pesti TK")
    ("Kispesti Gábor Áron Általános Iskola" "Külsõ-Pesti TK")
    ("Kispesti Károlyi Mihály Magyar-Spanyol Tannyelvû Gimnázium" "Külsõ-Pesti TK")
    ("Kispesti Móra Ferenc Óvoda, Általános Iskola, Egységes Gyógypedagógiai Módszertani Intézmény" "Külsõ-Pesti TK")
    ("Kispesti Puskás Ferenc Általános Iskola" "Külsõ-Pesti TK")
    ("Kispesti Szatmári László Alapfokú Mûvészeti Iskola Ady Endre Úti Telephelye" "Külsõ-Pesti TK")
    ("Kispesti Szatmári László Alapfokú Mûvészeti Iskola Csokonai Utcai Telephelye" "Külsõ-Pesti TK")
    ("Kispesti Szatmári László Alapfokú Mûvészeti Iskola Hungária út 28.sz. alatti Telephelye" "Külsõ-Pesti TK")
    ("Kispesti Szatmári László Alapfokú Mûvészeti Iskola Pannónia Úti Telephelye" "Külsõ-Pesti TK")
    ("Kispesti Vass Lajos Általános Iskola" "Külsõ-Pesti TK")
    ("Pestszentimrei Ady Endre Általános Iskola" "Külsõ-Pesti TK")
    ("Pestszentlõrinc-Pestszentimrei Felnõttek Általános Iskolája és Gimnáziuma" "Külsõ-Pesti TK")
    ("Bornemisza Géza Általános Iskola" "Mátészalkai TK")
    ("Cégénydányádi Általános Iskola Szamossályi Tagintézménye" "Mátészalkai TK")
    ("Dancs Lajos Általános Iskola" "Mátészalkai TK")
    ("Dr. Jósa István Általános Iskola" "Mátészalkai TK")
    ("Encsencs-Penészlek-Nyírvasvári Általános Iskola Nyírvasvári Tagintézménye" "Mátészalkai TK")
    ("Fábiánházi Általános Iskola" "Mátészalkai TK")
    ("Fehérgyarmati Deák Ferenc Általános Iskola, Gimnázium és Kollégium Általános Iskolája" "Mátészalkai TK")
    ("Fehérgyarmati Deák Ferenc Általános Iskola, Gimnázium és Kollégium Kossuth téri telephelye" "Mátészalkai TK")
    ("Gyõrteleki Fekete István Általános Iskola" "Mátészalkai TK")
    ("Jánkmajtisi Móricz Zsigmond Általános Iskola" "Mátészalkai TK")
    ("Jármi-Papos-Õr Általános Iskola" "Mátészalkai TK")
    ("Képes Géza Általános Iskola" "Mátészalkai TK")
    ("Kocsordi Jókai Mór Általános Iskola" "Mátészalkai TK")
    ("Kölcsei Kölcsey Ferenc Általános Iskola Penyigei Tagintézménye" "Mátészalkai TK")
    ("Makovecz Imre Általános Iskola Csengerújfalui Tagiskolája" "Mátészalkai TK")
    ("Makovecz Imre Általános Iskola Urai Tagiskolája" "Mátészalkai TK")
    ("Maróthy János Általános Iskola Gacsályi Tagiskolája" "Mátészalkai TK")
    ("Mátészalkai Móra Ferenc Óvoda, Általános Iskola, Egységes Gyógypedagógiai Módszertani Intézmény" "Mátészalkai TK")
    ("Mérk-Vállaj Német Nemzetiségi Általános Iskola" "Mátészalkai TK")
    ("Nagydobosi Általános Iskola" "Mátészalkai TK")
    ("Németh Lili Általános Iskola" "Mátészalkai TK")
    ("Nyírbátori Magyar - Angol Két Tanítási Nyelvû Általános Iskola" "Mátészalkai TK")
    ("Nyírbélteki Szent László Általános Iskola Ömbölyi Telephelye" "Mátészalkai TK")
    ("Nyírcsászári-Bátorliget-Terem-Nyírderzsi Általános Iskola" "Mátészalkai TK")
    ("Nyírcsászári-Bátorliget-Terem-Nyírderzsi Általános Iskola Teremi Telephelye" "Mátészalkai TK")
    ("Nyírgyulaji Kossuth Lajos Általános Iskola" 	"Mátészalkai TK")
    ("Nyírmeggyesi Arany János Általános Iskola" "Mátészalkai TK")
    ("Nyírparasznyai Általános Iskola" "Mátészalkai TK")
    ("Piricsei Eötvös József Általános Iskola" "Mátészalkai TK")
    ("Szabó Magda Általános Iskola" "Mátészalkai TK")
    ("Szatmár Alapfokú Mûvészeti Iskola" "Mátészalkai TK")
    ("Szatmár Alapfokú Mûvészeti Iskola Csengeri Telephelye" "Mátészalkai TK")
    ("Szatmár Alapfokú Mûvészeti Iskola Gyõrteleki Telephelye" "Mátészalkai TK")
    ("Szatmár Alapfokú Mûvészeti Iskola Jármi Telephelye" "Mátészalkai TK")
    ("Szatmár Alapfokú Mûvészeti Iskola Kölcsei Telephelye" "Mátészalkai TK")
    ("Szatmár Alapfokú Mûvészeti Iskola Nagydobosi Telephelye" "Mátészalkai TK")
    ("Szatmár Alapfokú Mûvészeti Iskola Nagyecsedi Telephelye" "Mátészalkai TK")
    ("Szatmár Alapfokú Mûvészeti Iskola Nyírbátori Debreceni utcai Telephelye" "Mátészalkai TK")
    ("Szatmár Alapfokú Mûvészeti Iskola Nyírbátori Tinódi Sebestyén Tagintézménye" "Mátészalkai TK")
    ("Szatmár Alapfokú Mûvészeti Iskola Nyírbélteki Telephelye" "Mátészalkai TK")
    ("Szatmár Alapfokú Mûvészeti Iskola Nyírmeggyesi Telephelye" "Mátészalkai TK")
    ("Szatmár Alapfokú Mûvészeti Iskola Õri Telephelye" "Mátészalkai TK")
    ("Szatmár Alapfokú Mûvészeti Iskola Piricsei Telephelye" "Mátészalkai TK")
    ("Szatmár Alapfokú Mûvészeti Iskola Szokolay utcai Telephelye" "Mátészalkai TK")
    ("Szatmárcsekei Kölcsey Ferenc Általános Iskola" "Mátészalkai TK")
    ("Tiszakóródi Hunyadi Mátyás Általános Iskola" "Mátészalkai TK")
    ("Tunyogmatolcsi Petõfi Sándor Általános Iskola" "Mátészalkai TK")
    ("Túristvándi Molnár Mátyás Általános Iskola Kömörõi Telephelye" "Mátészalkai TK")
    ("Tyukodi Általános Iskola Árpád út 35. Telephelye" "Mátészalkai TK")
    ("Vántus István Általános Iskola" "Mátészalkai TK")
    ("Béres János Alapfokú Mûvészeti Iskola" "Mezõkövesdi TK")
    ("Béres János Alapfokú Mûvészeti Iskola mezõkeresztesi telephelye" "Mezõkövesdi TK")
    ("Borsod-Abaúj-Zemplén Vármegyei Óvoda, Általános Iskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelést-Oktatást Végzõ Iskola, Kollégium és Egységes Gyógypedagógiai Módszertani Intézmény" "Mezõkövesdi TK")
    ("Bükkábrányi Arany János Általános Iskola" "Mezõkövesdi TK")
    ("Bükkalja Általános Iskola" "Mezõkövesdi TK")
    ("Dõry Ferenc Körzeti Általános Iskola" "Mezõkövesdi TK")
    ("Dr. Mészáros Kálmán Általános Iskola Ároktõ, Széchenyi utca 55. szám alatti Telephelye" "Mezõkövesdi TK")
    ("Hejõkeresztúri IV. Béla Általános Iskola" "Mezõkövesdi TK")
    ("Hejõpapi Általános Iskola" "Mezõkövesdi TK")
    ("Igrici Tompa Mihály Általános Iskola és Alapfokú Mûvészeti Iskola Telephelye" "Mezõkövesdi TK")
    ("Mezõcsáti Egressy Béni Általános Iskola és Alapfokú Mûvészeti Iskola" "Mezõkövesdi TK")
    ("Mezõkeresztesi Kossuth Lajos Általános Iskola" "Mezõkövesdi TK")
    ("Mezõkövesdi Általános Iskola Hórvölgye Tagiskolája" "Mezõkövesdi TK")
    ("Mezõkövesdi Általános Iskola Ódorvár Tagiskolája" "Mezõkövesdi TK")
    ("Mezõnagymihályi Arany János Általános Iskola" "Mezõkövesdi TK")
    ("Mezõnagymihályi Arany János Általános Iskola Tornaterme" "Mezõkövesdi TK")
    ("Sajószögedi Kölcsey Ferenc Körzeti Általános Iskola és Alapfokú Mûvészeti Iskola Hejõbábai Telephelye" "Mezõkövesdi TK")
    ("Sályi Gárdonyi Géza Általános Iskola" "Mezõkövesdi TK")
    ("Szentistváni István Király Általános Iskola Gárdonyi Géza Tagiskolája" "Mezõkövesdi TK")
    ("Tiszakeszi Széchenyi István Általános Iskola" "Mezõkövesdi TK")
    ("Tiszaújvárosi Eötvös József Gimnázium és Kollégium" "Mezõkövesdi TK")
    ("Tiszaújvárosi Hunyadi Mátyás Általános Iskola és Alapfokú Mûvészeti Iskola" "Mezõkövesdi TK")
    ("Tiszaújvárosi Hunyadi Mátyás Általános Iskola és Alapfokú Mûvészeti Iskola Vándor Sándor Zeneiskolája" "Mezõkövesdi TK")
    ("Alsózsolcai Herman Ottó Általános Iskola és Alapfokú Mûvészeti Iskola" "Miskolci TK")
    ("Alsózsolcai Herman Ottó Általános Iskola és Alapfokú Mûvészeti Iskola Telephelye" "Miskolci TK")
    ("Avasi Gimnázium" "Miskolci TK")
    ("Avastetõi Általános Iskola és Alapfokú Mûvészeti Iskola Kovács utcai Telephelye" "Miskolci TK")
    ("Avastetõi Általános Iskola és Alapfokú Mûvészeti Iskola Széchenyi István Általános és Alapfokú Mûvészeti Tagiskolája" "Miskolci TK")
    ("Borsod-Abaúj-Zemplén Vármegyei Pedagógiai Szakszolgálat" "Miskolci TK")
    ("Borsod-Abaúj-Zemplén Vármegyei Pedagógiai Szakszolgálat Edelényi Tagintézménye" "Miskolci TK")
    ("Borsod-Abaúj-Zemplén Vármegyei Pedagógiai Szakszolgálat Gönci Tagintézménye" "Miskolci TK")
    ("Borsod-Abaúj-Zemplén Vármegyei Pedagógiai Szakszolgálat Kazincbarcikai Tagintézmény Telephelye" "Miskolci TK")
    ("Borsod-Abaúj-Zemplén Vármegyei Pedagógiai Szakszolgálat Mezõcsáti Tagintézménye" "Miskolci TK")
    ("Borsod-Abaúj-Zemplén Vármegyei Pedagógiai Szakszolgálat Miskolci Tagintézmény Felsõzsolca Telephelye" "Miskolci TK")
    ("Borsod-Abaúj-Zemplén Vármegyei Pedagógiai Szakszolgálat Miskolci Tagintézménye Telephelye" "Miskolci TK")
    ("Borsod-Abaúj-Zemplén Vármegyei Pedagógiai Szakszolgálat Putnoki Tagintézménye" "Miskolci TK")
    ("Borsod-Abaúj-Zemplén Vármegyei Pedagógiai Szakszolgálat Sárospataki Tagintézménye" "Miskolci TK")
    ("Borsod-Abaúj-Zemplén Vármegyei Pedagógiai Szakszolgálat Szerencsi Tagintézménye" "Miskolci TK")
    ("Borsod-Abaúj-Zemplén Vármegyei Pedagógiai Szakszolgálat Tiszaújvárosi Tagintézménye" "Miskolci TK")
    ("Bulgárföldi Általános Iskola" "Miskolci TK")
    ("Bükki Szlovák Nemzetiségi Általános Iskola" "Miskolci TK")
    ("Bükki Szlovák Nemzetiségi Általános Iskola Répáshutai Tagiskolája" "Miskolci TK")
    ("Diósgyõri Nagy Lajos Király Általános Iskola" "Miskolci TK")
    ("Emõdi II. Rákóczi Ferenc Általános Iskola Kossuth u. 87. sz. alatti telephelye" "Miskolci TK")
    ("Fazekas Utcai Általános Iskola és Alapfokú Mûvészeti Iskola Dayka Gábor utcai Telephelye" "Miskolci TK")
    ("Görgey Artúr Általános Iskola és Alapfokú Mûvészeti Iskola" "Miskolci TK")
    ("Görömbölyi Általános Iskola Telephelye" "Miskolci TK")
    ("Harsányi Hunyadi Mátyás Általános Iskola" "Miskolci TK")
    ("Kisgyõri Általános Iskola" "Miskolci TK")
    ("Koncz József Általános Iskola és Alapfokú Mûvészeti Iskola" "Miskolci TK")
    ("Mályi Móra Ferenc Általános Iskola Telephelye" "Miskolci TK")
    ("Miskolci Bartók Béla Zene- és Táncmûvészeti Szakgimnázium" "Miskolci TK")
    ("Miskolci Egressy Béni Zenei Alapfokú Mûvészeti Iskola" 	"Miskolci TK")
    ("Miskolci Egressy Béni Zenei Alapfokú Mûvészeti Iskola Erkel Ferenc Tagiskolája Telephelye" 	"Miskolci TK")
    ("Miskolci Éltes Mátyás Óvoda, Általános Iskola és Egységes Gyógypedagógiai Módszertani Intézmény" "Miskolci TK")
    ("Miskolci Éltes Mátyás Óvoda, Általános Iskola és Egységes Gyógypedagógiai Módszertani Intézmény Tüskevár Tagóvodája és Tagiskolája" "Miskolci TK")
    ("Miskolci Éltes Mátyás Óvoda, Általános Iskola és Egységes Gyógypedagógiai Módszertani Intézmény Tüskevár Tagóvodája és Tagiskolája Szentpéteri kapu 72-76. Telephelye" "Miskolci TK")
    ("Miskolci Herman Ottó Gimnázium" "Miskolci TK")
    ("Miskolci Kazinczy Ferenc Magyar-Angol Két Tanítási Nyelvû Általános Iskola" "Miskolci TK")
    ("Miskolci Könyves Kálmán Általános Iskola és Alapfokú Mûvészeti Iskola" "Miskolci TK")
    ("Miskolci Petõfi Sándor Általános Iskola" "Miskolci TK")
    ("Miskolci Petõfi Sándor Általános Iskola Telephelye" "Miskolci TK")
    ("Miskolci Petõfi Sándor Kollégium Teleki Tehetséggondozó Tagkollégiuma" "Miskolci TK")
    ("Miskolci Szilágyi Dezsõ Általános Iskola" "Miskolci TK")
    ("Nyékládházi Kossuth Lajos Általános Iskola" "Miskolci TK")
    ("Rákóczi Julianna Általános Iskola" "Miskolci TK")
    ("Reményi Ede Zenei Alapfokú Mûvészeti Iskola" "Miskolci TK")
    ("Sajóbábonyi Deák Ferenc Általános Iskola" "Miskolci TK")
    ("Sajóvámosi Arany János Általános Iskola" "Miskolci TK")
    ("Beremendi Általános Iskola és Alapfokú Mûvészeti Iskola" "Mohácsi TK")
    ("Egyházasharaszti Körzeti Általános Iskola" "Mohácsi TK")
    ("Himesházi Általános Iskola és Alapfokú Mûvészeti Iskola" "Mohácsi TK")
    ("Kitaibel Pál Általános Iskola és Alapfokú Mûvészeti Iskola" "Mohácsi TK")
    ("Kitaibel Pál Általános Iskola és Alapfokú Mûvészeti Iskola Kémesi Telephelye" "Mohácsi TK")
    ("Lippói Gárdonyi Géza Általános Iskola" "Mohácsi TK")
    ("Meixner Ildikó EGYMI Bólyi Telephelye" "Mohácsi TK")
    ("Meixner Ildikó EGYMI Siklósi Tag Általános Iskolája, Készségfejlesztõ Iskolája, Fejlesztõ Nevelés-Oktatást Végzõ Iskolája" 	"Mohácsi TK")
    ("Meixner Ildikó Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Fejlesztõ Nevelés-Oktatást Végzõ Iskola, Készségfejlesztõ Iskola, Szakiskola és Kollégium" "Mohácsi TK")
    ("Mohács Térségi Általános Iskola Brodarics Téri Telephelye" "Mohácsi TK")
    ("Mohácsi Kisfaludy Károly Gimnázium" "Mohácsi TK")
    ("Munkácsy Albert Általános Iskola" "Mohácsi TK")
    ("Schneider Lajos Alapfokú Mûvészeti Iskola" "Mohácsi TK")
    ("Schneider Lajos Alapfokú Mûvészeti Iskola 006-os Telephelye" "Mohácsi TK")
    ("Siklósi Táncsics Mihály Gimnázium, Általános Iskola és Alapfokú Mûvészeti Iskola" "Mohácsi TK")
    ("Siklósi Táncsics Mihály Gimnázium, Általános Iskola és Alapfokú Mûvészeti Iskola  Batthyány Kázmér Általános Iskolája" "Mohácsi TK")
    ("Siklósi Táncsics Mihály Gimnázium, Általános Iskola és Alapfokú Mûvészeti Iskola Kémesi Telephelye" "Mohácsi TK")
    ("Siklósi Táncsics Mihály Gimnázium, Általános Iskola és Alapfokú Mûvészeti Iskola Siklós, Köztársaság téri Telephelye" "Mohácsi TK")
    ("Siklósi Táncsics Mihály Gimnázium, Általános Iskola és Alapfokú Mûvészeti Iskola Újpetrei Telephelye" "Mohácsi TK")
    ("Sombereki Kalász Márton Általános Iskola és Alapfokú Mûvészeti Iskola" "Mohácsi TK")
    ("Szederkényi Általános Iskola" "Mohácsi TK")
    ("Szederkényi Általános Iskola Szajki Tagiskolája" "Mohácsi TK")
    ("Véméndi Általános Iskola" "Mohácsi TK")
    ("Versendi Általános Iskola Szabadság utcai Telephelye" "Mohácsi TK")
    ("Villányi Általános Iskola és Alapfokú Mûvészeti Iskola Rákóczi utcai Telephelye" "Mohácsi TK")
    ("Alsónémedi Széchenyi István Általános Iskola" "Monori TK")
    ("Bénye-Káva Általános Iskola" "Monori TK")
    ("Bugyi Nagyközségi Kazinczy Ferenc Általános Iskola és Alapfokú Mûvészeti Iskola" "Monori TK")
    ("Cziffra György Alapfokú Mûvészeti Iskola Bartók Béla utcai Telephelye" "Monori TK")
    ("Cziffra György Alapfokú Mûvészeti Iskola Hernád, Fõ utca 149. szám alatti Telephelye" "Monori TK")
    ("Cziffra György Alapfokú Mûvészeti Iskola Inárcsi Telephelye" "Monori TK")
    ("Cziffra György Alapfokú Mûvészeti Iskola Táborfalvai Telephelye" "Monori TK")
    ("Cziffra György Alapfokú Mûvészeti Iskola Újlengyeli Telephelye" "Monori TK")
    ("Dabasi II. Rákóczi Ferenc Általános Iskola" "Monori TK")
    ("Dabasi Táncsics Mihály Gimnázium" "Monori TK")
    ("Gubányi Károly Általános Iskola" "Monori TK")
    ("Gubányi Károly Általános Iskola Szabadság téri Telephelye" "Monori TK")
    ("Gubányi Károly Általános Iskola Széchenyi utca 28. szám alatti Telephelye" "Monori TK")
    ("Gyáli Bartók Béla Általános Iskola" "Monori TK")
    ("Gyáli Kodály Zoltán Alapfokú Mûvészeti Iskola Felsõpakonyi Telephelye" "Monori TK")
    ("Gyáli Kodály Zoltán Alapfokú Mûvészeti Iskola Gyál, Kossuth Lajos utcai Telephelye" "Monori TK")
    ("Gyóni Géza Általános Iskola" "Monori TK")
    ("Gyömrõi Egységes Gyógypedagógiai Módszertani Intézmény, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Kollégium és Fejlesztõ Nevelés-Oktatást Végzõ Iskola Monori telephelye" "Monori TK")
    ("Gyömrõi Fekete István Általános Iskola" "Monori TK")
    ("Gyömrõi II. Rákóczi Ferenc Általános Iskola" "Monori TK")
    ("Gyömrõi Weöres Sándor Általános Iskola és Alapfokú Mûvészeti Iskola Bajcsy-Zsilinszky úti Telephelye" "Monori TK")
    ("Gyömrõi Weöres Sándor Általános Iskola és Alapfokú Mûvészeti Iskola Erzsébet utcai Telephelye" "Monori TK")
    ("Gyömrõi Weöres Sándor Általános Iskola és Alapfokú Mûvészeti Iskola Kossuth Ferenc utcai Telephelye" "Monori TK")
    ("Hernádi Általános Iskola" "Monori TK")
    ("Kakucsi Általános Iskola" "Monori TK")
    ("Maglódi Vermesy Péter Általános Iskola és Alapfokú Mûvészeti Iskola" "Monori TK")
    ("Maglódi Vermesy Péter Általános Iskola és Alapfokú Mûvészeti Iskola Aradi vértanúk utcai telephelye" "Monori TK")
    ("Maglódi Vermesy Péter Általános Iskola és Alapfokú Mûvészeti Iskola József Attila körút 33-35. alatti Telephelye" "Monori TK")
    ("Monori Budai Imre Alapfokú Mûvészeti Iskola" "Monori TK")
    ("Monori Budai Imre Alapfokú Mûvészeti Iskola Vasadi Telephelye" "Monori TK")
    ("Monori József Attila Gimnázium" "Monori TK")
    ("Monorierdei Fekete István Általános Iskola" "Monori TK")
    ("Múzsák Alapfokú Mûvészeti Iskola 2-es számú Ócsai telephelye" "Monori TK")
    ("Múzsák Alapfokú Mûvészeti Iskola Inárcsi Telephelye" "Monori TK")
    ("Múzsák Alapfokú Mûvészeti Iskola Kakucsi Telephelye" "Monori TK")
    ("Múzsák Alapfokú Mûvészeti Iskola Rákóczi Ferenc utcai Telephelye" "Monori TK")
    ("Múzsák Alapfokú Mûvészeti Iskola Szõlõ utcai Telephelye" "Monori TK")
    ("Nyáregyházi Nyáry Pál Általános Iskola és Alapfokú Mûvészeti Iskola" "Monori TK")
    ("Ócsai Halászy Károly Általános Iskola" "Monori TK")
    ("Pándi Általános Iskola Kultúr utca 1. szám alatti telephelye" "Monori TK")
    ("Pusztavacsi Általános Iskola" "Monori TK")
    ("Tolnay Lajos Általános Iskola" "Monori TK")
    ("Újlengyeli Általános Iskola" "Monori TK")
    ("Vasadi Általános Iskola" 	"Monori TK")
    ("Vecsési Andrássy Gyula Általános Iskola" "Monori TK")
    ("Vecsési Zenei Alapfokú Mûvészeti Iskola" "Monori TK")
    ("Vecsési Zenei Alapfokú Mûvészeti Iskola Halmy József téri Telephelye" "Monori TK")
    ("8808 Nagykanizsa, Alkotmány út 81" 	"Nagykanizsai TK")
    ("Becsehelyi Schmidt Egon Általános Iskola" "Nagykanizsai TK")
    ("Csány-Szendrey Általános Iskola Belvárosi Tagiskolája" "Nagykanizsai TK")
    ("Dr. Mezõ Ferenc Gimnázium" "Nagykanizsai TK")
    ("Egry József Általános Iskola és Alapfokú Mûvészeti Iskola" "Nagykanizsai TK")
    ("Farkas Ferenc Zene- és Aranymetszés Alapfokú Mûvészeti Iskola" "Nagykanizsai TK")
    ("Farkas Ferenc Zene- és Aranymetszés Alapfokú Mûvészeti Iskola Bajcsy-Zsilinszky úti telephelye" "Nagykanizsai TK")
    ("Farkas Ferenc Zene- és Aranymetszés Alapfokú Mûvészeti Iskola Hevesi utcai telephelye" "Nagykanizsai TK")
    ("Farkas Ferenc Zene- és Aranymetszés Alapfokú Mûvészeti Iskola Platán sori telephelye" "Nagykanizsai TK")
    ("Farkas Ferenc Zene- és Aranymetszés Alapfokú Mûvészeti Iskola Rozgonyi utca 25. alatti telephelye" "Nagykanizsai TK")
    ("Farkas Ferenc Zene- és Aranymetszés Alapfokú Mûvészeti Iskola Szepetneki telephelye" "Nagykanizsai TK")
    ("Galamboki Általános Iskola" "Nagykanizsai TK")
    ("Hevesi Sándor Általános Iskola" "Nagykanizsai TK")
    ("Hévízi Bibó István Gimnázium és Kollégium Rózsa közi Telephelye" "Nagykanizsai TK")
    ("Hévízi Illyés Gyula Általános Iskola és Alapfokú Mûvészeti Iskola" "Nagykanizsai TK")
    ("Keszthelyi Festetics György Zenei Alapfokú Mûvészeti Iskola" "Nagykanizsai TK")
    ("Keszthelyi Festetics György Zenei Alapfokú Mûvészeti Iskola Vonyarcvashegyi telephelye" "Nagykanizsai TK")
    ("Keszthelyi Vajda János Gimnázium" "Nagykanizsai TK")
    ("Keszthelyi Vajda János Gimnázium Erzsébet királyné utcai telephelye" "Nagykanizsai TK")
    ("Kiskanizsai Általános Iskola" "Nagykanizsai TK")
    ("Kõrösi Csoma Sándor-Péterfy Sándor Általános Iskola" "Nagykanizsai TK")
    ("Letenyei Alapfokú Mûvészeti Iskola Becsehelyi Telephelye" "Nagykanizsai TK")
    ("Letenyei Andrássy Gyula Általános Iskola" "Nagykanizsai TK")
    ("Muraszemenyei Általános Iskola" "Nagykanizsai TK")
    ("Nagyrécsei Körzeti Általános Iskola Miháldi Telephelye" 	"Nagykanizsai TK")
    ("Pusztamagyaródi Kenyeres Elemér Általános Iskola" "Nagykanizsai TK")
    ("Sármelléki Általános Iskola" "Nagykanizsai TK")
    ("Szabó István Általános Iskola" "Nagykanizsai TK")
    ("Szivárvány Óvoda, Fejlesztõ Nevelés-Oktatást Végzõ Iskola, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Egységes Gyógypedagógiai Módszertani Intézmény" "Nagykanizsai TK")
    ("Tótszerdahelyi Zrínyi Katarina Horvát Általános Iskola" "Nagykanizsai TK")
    ("Zalaapáti Gábor Áron Általános Iskola" "Nagykanizsai TK")
    ("Zalaszentbalázsi Petõfi Sándor Általános Iskola" "Nagykanizsai TK")
    ("Zrínyi Miklós Általános Iskola" "Nagykanizsai TK")
    ("Zrínyi Miklós Magyar-Angol Két Tanítási Nyelvû Általános Iskola Szent Imre utcai telephelye" "Nagykanizsai TK")
    ("Balkányi Szabolcs Vezér Általános Iskola és Alapfokú Mûvészeti Iskola" "Nyíregyházi TK")
    ("Buji II. Rákóczi Ferenc Általános Iskola és Alapfokú Mûvészeti Iskola" "Nyíregyházi TK")
    ("Erzsébet Királyné Német Nemzetiségi Általános Iskola és Alapfokú Mûvészeti Iskola Bocskai Úti Telephelye" "Nyíregyházi TK")
    ("Hankó László Zenei Alapfokú Mûvészeti Iskola Telephelye" "Nyíregyházi TK")
    ("Ibrányi Árpád Fejedelem Általános Iskola és Alapfokú Mûvészeti Iskola" "Nyíregyházi TK")
    ("Ibrányi Árpád Fejedelem Általános Iskola és Alapfokú Mûvészeti Iskola Ady utcai Telephelye" "Nyíregyházi TK")
    ("Ibrányi Árpád Fejedelem Általános Iskola Sényõi Tagintézménye" "Nyíregyházi TK")
    ("Kállay Miklós Általános Iskola" "Nyíregyházi TK")
    ("Nagycserkeszi Mikszáth Kálmán Általános Iskola" "Nyíregyházi TK")
    ("Nagykállói Általános Iskola és Alapfokú Mûvészeti Iskola Nagykállói Telephelye" "Nyíregyházi TK")
    ("Napkori Jósika Miklós Német Nemzetiségi Általános Iskola és Alapfokú Mûvészeti Iskola" "Nyíregyházi TK")
    ("Nyíregyházi Arany János Gimnázium, Általános Iskola és Kollégium" "Nyíregyházi TK")
    ("Nyíregyházi Arany János Gimnázium, Általános Iskola és Kollégium Szõlõskerti Angol Kéttannyelvû Tagintézménye" "Nyíregyházi TK")
    ("Nyíregyházi Bárczi Gusztáv Általános Iskola, Készségfejlesztõ Iskola, Kollégium és Egységes Gyógypedagógiai Módszertani Intézmény" "Nyíregyházi TK")
    ("Nyíregyházi Bárczi Gusztáv Általános Iskola, Készségfejlesztõ Iskola, Kollégium és Egységes Gyógypedagógiai Módszertani Intézmény Szarvas Utcai Telephelye" "Nyíregyházi TK")
    ("Nyíregyházi Bem József Általános Iskola Gárdonyi Géza Tagintézménye" "Nyíregyházi TK")
    ("Nyíregyházi Bem József Általános Iskola Kazinczy Ferenc Tagintézménye" "Nyíregyházi TK")
    ("Nyíregyházi Kodály Zoltán Általános Iskola" "Nyíregyházi TK")
    ("Nyíregyházi Krúdy Gyula Gimnázium" "Nyíregyházi TK")
    ("Nyíregyházi Móra Ferenc Általános Iskola Petõfi Sándor Tagintézménye" "Nyíregyházi TK")
    ("Nyíregyházi Móricz Zsigmond Általános Iskola Kertvárosi Tagintézménye" "Nyíregyházi TK")
    ("Nyíregyházi Móricz Zsigmond Általános Iskola Váci Mihály Tagintézménye" "Nyíregyházi TK")
    ("Nyíregyházi Mûvészeti Szakgimnázium" "Nyíregyházi TK")
    ("Nyíregyházi RIDENS Gimnázium, Szakiskola és Kollégium" "Nyíregyházi TK")
    ("Nyíregyházi Zrínyi Ilona Gimnázium és Kollégium" "Nyíregyházi TK")
    ("Nyírturai Móra Ferenc Általános Iskola" "Nyíregyházi TK")
    ("Rakovszky Sámuel Általános Iskola és Alapfokú Mûvészeti Iskola" "Nyíregyházi TK")
    ("Szabolcs-Szatmár-Bereg Vármegyei Pedagógiai Szakszolgálat Baktalórántházi Tagintézménye" "Nyíregyházi TK")
    ("Szabolcs-Szatmár-Bereg Vármegyei Pedagógiai Szakszolgálat Fehérgyarmati Tagintézménye" "Nyíregyházi TK")
    ("Szabolcs-Szatmár-Bereg Vármegyei Pedagógiai Szakszolgálat Kemecsei Tagintézménye" "Nyíregyházi TK")
    ("Szabolcs-Szatmár-Bereg Vármegyei Pedagógiai Szakszolgálat Mátészalkai Megyei Tagintézménye" "Nyíregyházi TK")
    ("Szabolcs-Szatmár-Bereg Vármegyei Pedagógiai Szakszolgálat Nagykállói Tagintézménye" "Nyíregyházi TK")
    ("Szabolcs-Szatmár-Bereg Vármegyei Pedagógiai Szakszolgálat Nyírbátori Tagintézménye" "Nyíregyházi TK")
    ("Szabolcs-Szatmár-Bereg Vármegyei Pedagógiai Szakszolgálat Nyíregyházi Tagintézménye Rakamaz Telephelye" "Nyíregyházi TK")
    ("Szabolcs-Szatmár-Bereg Vármegyei Pedagógiai Szakszolgálat Tiszavasvári Tagintézménye" "Nyíregyházi TK")
    ("Szabolcs-Szatmár-Bereg Vármegyei Pedagógiai Szakszolgálat Záhonyi Tagintézménye" "Nyíregyházi TK")
    ("Szakolyi Arany János Általános Iskola" "Nyíregyházi TK")
    ("Tiszadadai Holló László Általános Iskola" "Nyíregyházi TK")
    ("Tiszadobi Széchenyi István Általános Iskola és Alapfokú Mûvészeti Iskola Táncsics utcai Telephely" "Nyíregyházi TK")
    ("Tiszalöki Kossuth Lajos Általános Iskola és Alapfokú Mûvészeti Iskola" "Nyíregyházi TK")
    ("Tiszanagyfalui Általános Iskola" "Nyíregyházi TK")
    ("Tiszanagyfalui Általános Iskola Tornaterme" "Nyíregyházi TK")
    ("Tiszavasvári Kabay János Általános Iskola" "Nyíregyházi TK")
    ("Tiszavasvári Váci Mihály Gimnázium" "Nyíregyházi TK")
    ("Újfehértói Erkel Ferenc Általános Iskola és Alapfokú Mûvészeti Iskola Kálmánháza Nyíregyházi út 30. Telephelye" "Nyíregyházi TK")
    ("Újfehértói Erkel Ferenc Általános Iskola és Alapfokú Mûvészeti Iskola Széchenyi utca 3. Telephelye" "Nyíregyházi TK")
    ("Vikár Sándor Zeneiskola - Alapfokú Mûvészeti Iskola Nyírpazonyi telephelye" "Nyíregyházi TK")
    ("Ajkai Bródy Imre Gimnázium" 	"Pápai TK")
    ("Ajkai Eötvös Loránd - Kossuth Lajos Általános Iskola Eötvös utcai telephelye" "Pápai TK")
    ("Csöglei Általános Iskola" "Pápai TK")
    ("Devecseri Gárdonyi Géza Általános Iskola és Alapfokú Mûvészeti Iskola Petõfi Sándor Téri Telephelye" "Pápai TK")
    ("Fekete István - Vörösmarty Mihály Általános Iskola, Gimnázium József Attila utcai Telephelye" "Pápai TK")
    ("Kastély Német Nemzetiségi Nyelvoktató Általános Iskola" "Pápai TK")
    ("Kocsár Miklós Zeneiskola és Alapfokú Mûvészeti Iskola" "Pápai TK")
    ("Kocsár Miklós Zeneiskola és Alapfokú Mûvészeti Iskola Ajka, Dobó Katica utcai Telephelye" "Pápai TK")
    ("Kocsár Miklós Zeneiskola és Alapfokú Mûvészeti Iskola Ajka, Kislõd Telephelye" "Pápai TK")
    ("Laschober Mária Német Nemzetiségi Nyelvoktató Általános Iskola" "Pápai TK")
    ("Magyarpolányi Kerek Nap Német Nemzetiségi Nyelvoktató Általános Iskola és Alapfokú Mûvészeti Iskola" "Pápai TK")
    ("Magyarpolányi Kerek Nap Német Nemzetiségi Nyelvoktató Általános Iskola és Alapfokú Mûvészeti Iskola Ajka, Gyepesi utcai Telephelye" "Pápai TK")
    ("Magyarpolányi Kerek Nap Német Nemzetiségi Nyelvoktató Általános Iskola és Alapfokú Mûvészeti Iskola Ajka, Móra Ferenc utcai Telephelye" "Pápai TK")
    ("Magyarpolányi Kerek Nap Német Nemzetiségi Nyelvoktató Általános Iskola és Alapfokú Mûvészeti Iskola Csöglei Telephelye" "Pápai TK")
    ("Magyarpolányi Kerek Nap Német Nemzetiségi Nyelvoktató Általános Iskola és Alapfokú Mûvészeti Iskola Dobó K. utcai Telephelye" "Pápai TK")
    ("Magyarpolányi Kerek Nap Német Nemzetiségi Nyelvoktató Általános Iskola és Alapfokú Mûvészeti Iskola Kertai Telephelye" "Pápai TK")
    ("Magyarpolányi Kerek Nap Német Nemzetiségi Nyelvoktató Általános Iskola és Alapfokú Mûvészeti Iskola Noszlopi Telephelye" "Pápai TK")
    ("Magyarpolányi Kerek Nap Német Nemzetiségi Nyelvoktató Általános Iskola és Alapfokú Mûvészeti Iskola Somlóvásárhelyi Telephelye" "Pápai TK")
    ("Magyarpolányi Kerek Nap Német Nemzetiségi Nyelvoktató Általános Iskola és Alapfokú Mûvészeti Iskola Városlõdi Telephelye" "Pápai TK")
    ("Magyarpolányi Kerek Nap Német Nemzetiségi Nyelvoktató Általános Iskola és Alapfokú Mûvészeti Iskola, Magyarpolány Iskola utcai Telephelye" "Pápai TK")
    ("Magyarpolányi Kerek Nap Német Nemzetiségi Nyelvoktató Általános Iskola és Alapfokú Mûvészeti Iskola, Nyirádi Telephelye" "Pápai TK")
    ("Mezõlaki Arany János Általános Iskola" "Pápai TK")
    ("Molnár Gábor Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola és Egységes Gyógypedagógiai Módszertani Intézmény Gyár utcai Telephelye" "Pápai TK")
    ("Nagyalásonyi Kinizsi Pál Általános Iskola" "Pápai TK")
    ("Noszlopi Német Nemzetiségi Nyelvoktató Általános Iskola" "Pápai TK")
    ("Nyirádi Erzsébet Királyné Általános Iskola Dr. Szalai Miklós Tagintézménye" "Pápai TK")
    ("Nyirádi Erzsébet Királyné Általános Iskola Tornaterme" "Pápai TK")
    ("Pápai Bartók Béla Alapfokú Mûvészeti Iskola Csóti Telephelye" "Pápai TK")
    ("Pápai Bartók Béla Alapfokú Mûvészeti Iskola pápai Telephelye" "Pápai TK")
    ("Pápai Bartók Béla Alapfokú Mûvészeti Iskola Ugodi Telephelye" "Pápai TK")
    ("Pápai Petõfi Sándor Gimnázium" "Pápai TK")
    ("Pápateszéri Általános Iskola" "Pápai TK")
    ("Somlóvásárhelyi Széchenyi István Általános Iskola Sport utcai telephelye" "Pápai TK")
    ("Tarczy Lajos Általános Iskola" "Pápai TK")
    ("Türr István Gimnázium és Kollégium" "Pápai TK")
    ("Ugodi Német Nemzetiségi Nyelvoktató Általános Iskola és Alapfokú Mûvészeti Iskola" "Pápai TK")
    ("Vajda Márta Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Egységes Gyógypedagógiai Módszertani Intézmény" "Pápai TK")
    ("Baranya Vármegyei Pedagógiai Szakszolgálat" "Pécsi TK")
    ("Baranya Vármegyei Pedagógiai Szakszolgálat Komlói Tagintézménye" "Pécsi TK")
    ("Baranya Vármegyei Pedagógiai Szakszolgálat Pécsi Tagintézménye" "Pécsi TK")
    ("Baranya Vármegyei Pedagógiai Szakszolgálat Pécsváradi Tagintézménye" "Pécsi TK")
    ("Baranya Vármegyei Pedagógiai Szakszolgálat Sellyei Tagintézménye" "Pécsi TK")
    ("Baranya Vármegyei Pedagógiai Szakszolgálat Szentlõrinci Tagintézménye" "Pécsi TK")
    ("Berkesdi Fekete István Általános Iskola" "Pécsi TK")
    ("Egyházaskozár-Bikal Általános Iskola Bikali Tagintézménye" "Pécsi TK")
    ("Hosszúhetényi Általános Iskola és Alapfokú Mûvészeti Iskola" "Pécsi TK")
    ("Kiss György Általános Iskola és Alapfokú Mûvészeti Iskola" "Pécsi TK")
    ("Kodolányi János Német Nemzetiségi Általános Iskola és Alapfokú Mûvészeti Iskola Geresdlaki Német Nemzetiségi Tagiskolája" "Pécsi TK")
    ("Kodolányi János Német Nemzetiségi Általános Iskola és Alapfokú Mûvészeti Iskola Pécsvárad, Kossuth Lajos Utca 31. sz. Alatti Telephelye" "Pécsi TK")
    ("Komlói Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Fejlesztõ Nevelés-Oktatást Végzõ Iskola, Készségfejlesztõ Iskola, Szakiskola és Kollégium" "Pécsi TK")
    ("Kökönyösi Általános Iskola, Gimnázium és Alapfokú Mûvészeti Iskola" "Pécsi TK")
    ("Kökönyösi Gimnázium Erkel Ferenc Alapfokú Mûvészeti Iskolája" "Pécsi TK")
    ("Kökönyösi Gimnázium Magyarszéki Általános Iskolája" "Pécsi TK")
    ("Liszt Ferenc Német Nemzetiségi Általános Iskola és Alapfokú Mûvészeti Iskola Mecseknádasdi Telephelye" "Pécsi TK")
    ("Pécsi Apáczai Csere János Általános Iskola, Gimnázium, Kollégium, Alapfokú Mûvészeti iskola 1. Sz. Általános Iskolája" "Pécsi TK")
    ("Pécsi Apáczai Csere János Általános Iskola, Gimnázium, Kollégium, Alapfokú Mûvészeti Iskola Kollégiuma" "Pécsi TK")
    ("Pécsi Árpád Fejedelem Gimnázium és Általános Iskola" "Pécsi TK")
    ("Pécsi Bánki Donát Utcai Általános Iskola Abaligeti Általános Iskolája" "Pécsi TK")
    ("Pécsi Bártfa Utcai Általános Iskola" "Pécsi TK")
    ("Pécsi Éltes Mátyás Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Fejlesztõ Nevelés-Oktatást Végzõ Iskola, Készségfejlesztõ Iskola és Kollégium" "Pécsi TK")
    ("Pécsi Hajnóczy József Kollégium" "Pécsi TK")
    ("Pécsi Janus Pannonius Gimnázium" "Pécsi TK")
    ("Pécsi Jurisics Utcai Általános Iskola" "Pécsi TK")
    ("Pécsi Kodály Zoltán Gimnázium Névtelen utcai Telephelye" "Pécsi TK")
    ("Pécsi Kovács Béla Általános Iskola" "Pécsi TK")
    ("Pécsi Leõwey Klára Gimnázium" "Pécsi TK")
    ("Pécsi Liszt Ferenc Zeneiskola-Alapfokú Mûvészeti Iskola" "Pécsi TK")
    ("Pécsi Martyn Ferenc Alapfokú Mûvészeti Iskola" "Pécsi TK")
    ("Pécsi Meszesi Általános Iskola" "Pécsi TK")
    ("Pécsi Meszesi Általános Iskola Vasas-Somogy-Hirdi Általános Iskolája" "Pécsi TK")
    ("Pécsi Mezõszél Utcai Általános Iskola" "Pécsi TK")
    ("Pécsi Szieberth Róbert Általános Iskola és Alapfokú Mûvészeti Iskola" "Pécsi TK")
    ("Pellérdi Általános Iskola" "Pécsi TK")
    ("Pellérdi Általános Iskola Gyódi Telephelye" "Pécsi TK")
    ("Szalántai Általános Iskola" "Pécsi TK")
    ("Szilvási Általános Iskola" "Pécsi TK")
    ("Aba Sámuel Általános Iskola" 	"Salgótarjáni TK")
    ("Aba Sámuel Általános Iskola Kazári Telephelye" "Salgótarjáni TK")
    ("Bátonyterenyei Bartók Béla Általános Iskola" "Salgótarjáni TK")
    ("Bátonyterenyei Erkel Ferenc Alapfokó Mûvészeti Iskola Dorogházi Telephelye" "Salgótarjáni TK")
    ("Bátonyterenyei Erkel Ferenc Alapfokú Mûvészeti Iskola Jászai út 2. alatti Telephelye" "Salgótarjáni TK")
    ("Bátonyterenyei Erkel Ferenc Alapfokú Mûvészeti Iskola Kazári Telephelye" "Salgótarjáni TK")
    ("Bátonyterenyei Erkel Ferenc Alapfokú Mûvészeti Iskola Mátranováki Telephelye" "Salgótarjáni TK")
    ("Bátonyterenyei Erkel Ferenc Alapfokú Mûvészeti Iskola Sóshartyáni telephelye" "Salgótarjáni TK")
    ("Bátonyterenyei Kossuth Lajos Általános Iskola" "Salgótarjáni TK")
    ("Dr. Krepuska Géza Általános Iskola" "Salgótarjáni TK")
    ("Ecsegi II. Rákóczi Ferenc Általános Iskola" "Salgótarjáni TK")
    ("Ecsegi II. Rákóczi Ferenc Általános Iskola Telephelye" "Salgótarjáni TK")
    ("Héhalmi Benedek Elek Általános Iskola" "Salgótarjáni TK")
    ("Id. Szabó István Általános Iskola" "Salgótarjáni TK")
    ("Illyés Gyuláné Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Szakiskola, Fejlesztõ Nevelés-oktatást Végzõ Iskola és Készségfejlesztõ Iskola 018/3 HRSZ.-i telephelye" "Salgótarjáni TK")
    ("Illyés Gyuláné Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Szakiskola, Fejlesztõ Nevelés-oktatást Végzõ Iskola és Készségfejlesztõ Iskola Füleki úti telephelye" "Salgótarjáni TK")
    ("Kállói II. Rákóczi Ferenc Általános Iskola" "Salgótarjáni TK")
    ("Lucfalvi Általános Iskola" "Salgótarjáni TK")
    ("Lucfalvi Általános Iskola Telephelye" "Salgótarjáni TK")
    ("Mikszáth Kálmán Gimnázium és Kollégium" "Salgótarjáni TK")
    ("Mikszáth Kálmán Gimnázium és Kollégium Tittel Pál Középiskolai Kollégiuma" "Salgótarjáni TK")
    ("Mocsáry Antal Általános Iskola Etesi Tagintézménye" "Salgótarjáni TK")
    ("Mocsáry Antal Általános Iskola Karancsaljai Tagintézménye" "Salgótarjáni TK")
    ("Mocsáry Antal Általános Iskola Karancsaljai Tagintézménye Rákóczi út 130. Telephelye" "Salgótarjáni TK")
    ("Mocsáry Antal Általános Iskola Kossuth út 9. Telephelye" "Salgótarjáni TK")
    ("Nógrád Vármegyei Pedagógiai Szakszolgálat Balassagyarmati Tagintézménye" "Salgótarjáni TK")
    ("Nógrád Vármegyei Pedagógiai Szakszolgálat Pásztói Tagintézménye" "Salgótarjáni TK")
    ("Nógrád Vármegyei Pedagógiai Szakszolgálat Salgótarjáni Tagintézménye" "Salgótarjáni TK")
    ("Nógrád Vármegyei Pedagógiai Szakszolgálat Telephelye" "Salgótarjáni TK")
    ("Pásztói Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelés-oktatást Végzõ Iskola és Kollégium" "Salgótarjáni TK")
    ("Platthy József Általános Iskola Telephelye" "Salgótarjáni TK")
    ("Rajeczky Benjámin Alapfokú Mûvészeti Iskola Csécse Madách u. 6. szám alatti Telephelye" "Salgótarjáni TK")
    ("Rajeczky Benjámin Alapfokú Mûvészeti Iskola Szurdokpüspöki Telephelye" "Salgótarjáni TK")
    ("Ságújfalui Általános Iskola"  	"Salgótarjáni TK")
    ("Salgótarjáni Általános Iskola Beszterce-lakótelepi Tagiskolája" "Salgótarjáni TK")
    ("Salgótarjáni Általános Iskola Dornyay Béla Tagiskolájának Telephelye" "Salgótarjáni TK")
    ("Salgótarjáni Általános Iskola és Kollégium József Attila úti Telephely" "Salgótarjáni TK")
    ("Salgótarjáni Általános Iskola Kodály Zoltán Tagiskolája" "Salgótarjáni TK")
    ("Salgótarjáni Általános Iskola Petõfi Sándor Tagiskolája" "Salgótarjáni TK")
    ("Salgótarjáni Bolyai János Gimnázium" "Salgótarjáni TK")
    ("Szurdokpüspöki Általános Iskola" "Salgótarjáni TK")
    ("Tari Kodály Zoltán Általános Iskola Mátraverebélyi Telephelye" "Salgótarjáni TK")
    ("Váczi Gyula Alapfokú Mûvészeti Iskola Acélgyári út 24. szám Alatti Telephelye" "Salgótarjáni TK")
    ("Váczi Gyula Alapfokú Mûvészeti Iskola Beszterce téri Telephelye" "Salgótarjáni TK")
    ("Váczi Gyula Alapfokú Mûvészeti Iskola Forgách Antal úti Telephelye" "Salgótarjáni TK")
    ("Váczi Gyula Alapfokú Mûvészeti Iskola Karancsalja, Rákóczi úti telephelye" "Salgótarjáni TK")
    ("Váczi Gyula Alapfokú Mûvészeti Iskola Karancslapujtõi Tagintézményének Litkei Telephelye" "Salgótarjáni TK")
    ("Váczi Gyula Alapfokú Mûvészeti Iskola Kissomlyó úti Telephelye" "Salgótarjáni TK")
    ("Váczi Gyula Alapfokú Mûvészeti Iskola Március 15. úti Telephely" "Salgótarjáni TK")
    ("Váczi Gyula Alapfokú Mûvészeti Iskola Somoskõújfalui Telephelye" "Salgótarjáni TK")
    ("Boldogkõváraljai Körzeti Általános Iskola" "Sárospataki TK")
    ("Deák Úti EGYMI Boldogkõváralja, Kossuth utca 2. Szám Alatti Telephelye" "Sárospataki TK")
    ("Deák Úti Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelést-Oktatást Végzõ Iskola, Kollégium, Egységes Gyógypedagógiai Módszertani Intézmény" "Sárospataki TK")
    ("Farkas Ferenc Alapfokú Mûvészeti Iskola Bodroghalom telephelye" "Sárospataki TK")
    ("Farkas Ferenc Alapfokú Mûvészeti Iskola Hercegkúti telephelye" "Sárospataki TK")
    ("Farkas Ferenc Alapfokú Mûvészeti Iskola Pácin telephelye" "Sárospataki TK")
    ("Farkas Ferenc Alapfokú Mûvészeti Iskola Ricse Kossuth utca 3. telephelye" "Sárospataki TK")
    ("Farkas Ferenc Alapfokú Mûvészeti Iskola Sárospatak Szent Erzsébet út 12. telephelye" "Sárospataki TK")
    ("Farkas Ferenc Alapfokú Mûvészeti Iskola Vajdácskai telephelye" "Sárospataki TK")
    ("Hegyközi Általános Iskola Kovácsvágási II. Rákóczi Ferenc Tagintézménye" "Sárospataki TK")
    ("Hegyközi Nyelvoktató Szlovák Nemzetiségi Általános Iskola Füzérkomlósi telephelye" "Sárospataki TK")
    ("Hidasnémeti II. Rákóczi Ferenc Magyar-Szlovák Két Tanítási Nyelvû Általános Iskola" "Sárospataki TK")
    ("Kántor Mihály Általános Iskola" "Sárospataki TK")
    ("Kántor Mihály Általános Iskola Révleányvári Telephelye" "Sárospataki TK")
    ("Karcsai Általános Iskola" 	"Sárospataki TK")
    ("Kazinczy Ferenc Általános Iskola Balassi Bálint utcai Telephelye" "Sárospataki TK")
    ("Kazinczy Ferenc Általános Iskola Jókai Mór Tagintézménye" "Sárospataki TK")
    ("Kazinczy Ferenc Általános Iskola Mikóházi Lõrincze Lajos Tagintézménye" "Sárospataki TK")
    ("Kenézlõi Általános Iskola" "Sárospataki TK")
    ("Lavotta János Alapfokú Mûvészeti Iskola" "Sárospataki TK")
    ("Lavotta János Alapfokú Mûvészeti Iskola Deák utcai Telephelye" "Sárospataki TK")
    ("Lavotta János Alapfokú Mûvészeti Iskola Esze Tamás utcai Telephelye" "Sárospataki TK")
    ("Lavotta János Alapfokú Mûvészeti Iskola Füzérkomlósi Telephelye" "Sárospataki TK")
    ("Lavotta János Alapfokú Mûvészeti Iskola Jókai utcai Telephelye" "Sárospataki TK")
    ("Lavotta János Alapfokú Mûvészeti Iskola Kovácsvágási Telephelye" "Sárospataki TK")
    ("Lavotta János Alapfokú Mûvészeti Iskola Pálházi Telephelye" "Sárospataki TK")
    ("Molnár Mózes Általános Iskola" "Sárospataki TK")
    ("Molnár Mózes Általános Iskola Vajdácskai Telephelye" "Sárospataki TK")
    ("Olaszliszkai Hegyalja Általános Iskola" "Sárospataki TK")
    ("Olaszliszkai Hegyalja Általános Iskola Szent István utcai Telephelye" "Sárospataki TK")
    ("Pécsvárady Botond Óvoda, Általános Iskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelést-Oktatást Végzõ Iskola, Kollégium, Egységes Gyógypedagógiai Módszertani Intézmény" "Sárospataki TK")
    ("Ricsei II. Rákóczi Ferenc Általános Iskola Telephelye" "Sárospataki TK")
    ("Sárospataki Árpád Vezér Gimnázium és Kollégium" 	"Sárospataki TK")
    ("Sárospataki II. Rákóczi Ferenc Általános Iskola" "Sárospataki TK")
    ("Sárospataki II. Rákóczi Ferenc Általános Iskola Telephelye" "Sárospataki TK")
    ("Tolcsvai Általános Iskola Kossuth Lajos út 62. szám alatti Telephelye" "Sárospataki TK")
    ("Vilmányi II. Rákóczi Ferenc Általános Iskola" "Sárospataki TK")
    ("Zempléni Általános Iskola" "Sárospataki TK")
    ("Batthyány Lajos Általános Iskola" 	"Sárvári TK")
    ("Bersek József Általános Iskola" "Sárvári TK")
    ("Bõi Általános Iskola" "Sárvári TK")
    ("Budaker Gusztáv Zeneiskola - Alapfokú Mûvészeti Iskola" "Sárvári TK")
    ("Budaker Gusztáv Zeneiskola Alapfokú Mûvészeti Iskola Horvátzsidányi Telephelye" "Sárvári TK")
    ("Celldömölki Ádám Jenõ Alapfokú Mûvészeti Iskola Tagiskolája" "Sárvári TK")
    ("Celldömölki Berzsenyi Dániel Gimnázium" "Sárvári TK")
    ("Celldömölki Városi Általános Iskola Széchenyi utca 16. sz. alatti telephelye" "Sárvári TK")
    ("Dr. Csepregi Horváth János Általános Iskola" "Sárvári TK")
    ("Dr. Nagy László EGYMI Sárvári Telephelye" "Sárvári TK")
    ("Dr. Tolnay Sándor Általános Iskola" "Sárvári TK")
    ("Gércei Általános Iskola" "Sárvári TK")
    ("Gércei Általános Iskola Kossuth Lajos utcai Telephelye" "Sárvári TK")
    ("Jurisich Miklós Gimnázium és Kollégium" "Sárvári TK")
    ("Kemenesmagasi Általános Iskola" 	"Sárvári TK")
    ("Koncz János Alapfokú Mûvészeti Iskola Batthyány u. 29. telephelye" "Sárvári TK")
    ("Koncz János Alapfokú Mûvészeti Iskola Ikervári telephelye" "Sárvári TK")
    ("Koncz János Alapfokú Mûvészeti Iskola Répcelaki telephelye" "Sárvári TK")
    ("Koncz János Alapfokú Mûvészeti Iskola Várkerület u. 1. telephelye" "Sárvári TK")
    ("Ostffyasszonyfai Petõfi Sándor Általános Iskola" "Sárvári TK")
    ("Ostffyasszonyfai Petõfi Sándor Általános Iskola Kenyeri Telephelye" "Sárvári TK")
    ("Répcelaki Móra Ferenc Általános Iskola" 	"Sárvári TK")
    ("Répcelaki Móra Ferenc Általános Iskola Uraiújfalui Telephelye" "Sárvári TK")
    ("Sárvári Nádasdy Tamás Általános Iskola" "Sárvári TK")
    ("Szelestei Általános Iskola Ölbõ, Kossuth Lajos utca 4. szám alatti Telephelye" "Sárvári TK")
    ("Zichy Antónia Általános Iskola" "Sárvári TK")
    ("Zichy Antónia Általános Iskola Gróf Erdõdy Ferenc Telephelye" "Sárvári TK")
    ("Ádándi Fekete István Általános Iskola" "Siófoki TK")
    ("Andocsi Szent Ferenc Általános Iskola és Alapfokú Mûvészeti Iskola Törökkoppányi Telephelye" "Siófoki TK")
    ("Balatonfenyvesi Fekete István Általános Iskola" "Siófoki TK")
    ("Balatonlelle-Karádi Általános Iskola és Alapfokú Mûvészeti Iskola" "Siófoki TK")
    ("Balatonlelle-Karádi Általános Iskola Gárdonyi Géza Tagiskola Kossuth Parki Telephelye" "Siófoki TK")
    ("Balatonszabadi Kincskeresõ Általános Iskola" "Siófoki TK")
    ("Balatonszemesi Reich Károly Általános Iskola" "Siófoki TK")
    ("Balatonszentgyörgyi Dobó István Általános Iskola Sávoly Tagintézménye Somogysámsoni Telephelye" "Siófoki TK")
    ("Balatonvilágosi Mészöly Géza Általános Iskola" "Siófoki TK")
    ("Boglári Általános Iskola és Alapfokú Mûvészeti Iskola Árpád utcai Telephelye" "Siófoki TK")
    ("Boglári Kollégium" "Siófoki TK")
    ("Festetics Pál Általános Iskola és Alapfokú Mûvészeti Iskola" "Siófoki TK")
    ("Festetics Pál Általános Iskola és Alapfokú Mûvészeti Iskola Somogyfajszi Tagintézményének Pusztakovácsi Telephelye" "Siófoki TK")
    ("Fodor András Általános Iskola, Alapfokú Mûvészeti Iskola Buzsáki Telephelye" "Siófoki TK")
    ("Fonyódi Alapfokú Mûvészeti Iskola" "Siófoki TK")
    ("Gróf Széchényi Imre Általános Iskola és Alapfokú Mûvészeti Iskola" "Siófoki TK")
    ("Gróf Széchényi Imre Általános Iskola és Alapfokú Mûvészeti Iskola Ránki György Alapfokú Mûvészeti Tagiskolája" "Siófoki TK")
    ("Gróf Széchéyi Imre Általános Iskola és Alapfokú Mûvészeti Iskola Ránki György Alapfokú Mûvészeti Tagiskolája Balatonendrédi Telephelye" "Siófoki TK")
    ("Kéthelyi Széchenyi István Általános Iskola és Alapfokú Mûvészeti Iskola" "Siófoki TK")
    ("Látrányi Fekete István Általános Iskola" "Siófoki TK")
    ("Marcali Hétszínvirág Általános Iskola, Készségfejlesztõ Iskola, Egységes Gyógypedagógiai Módszertani Intézmény" "Siófoki TK")
    ("Marcali Noszlopy Gáspár Általános Iskola és Alapfokú Mûvészeti Iskola" "Siófoki TK")
    ("Marcali Noszlopy Gáspár Általános Iskola és Alapfokú Mûvészeti Iskola Hidas Frigyes Alapfokú Mûvészeti Iskolája Balatonkeresztúri Telephelye" "Siófoki TK")
    ("Mátyás Király Gimnázium és Kollégium" "Siófoki TK")
    ("Nagyberényi Dr. Faust Miklós Általános Iskola" "Siófoki TK")
    ("Palonai Magyar Bálint Általános Iskola" "Siófoki TK")
    ("Siófoki Beszédes József Általános Iskola" "Siófoki TK")
    ("Siófoki Perczel Mór Gimnázium és Kollégium Aranypart Kollégiuma" "Siófoki TK")
    ("Siófoki Széchenyi István Általános Iskola Asztalos utca 18. Telephelye" "Siófoki TK")
    ("Siófoki Vak Bottyán János Általános Iskola Asztalos Utcai Telephelye" "Siófoki TK")
    ("Siófoki Vak Bottyán János Általános Iskola és Alapfokú Mûvészeti Iskola Balatonszabadi Telephelye" "Siófoki TK")
    ("Siófoki Vak Bottyán János Általános Iskola és Alapfokú Mûvészeti Iskola Nagyberényi Telephelye" "Siófoki TK")
    ("Siófoki Vak Bottyán János Általános Iskola és Alapfokú Mûvészeti Iskola Szépvölgyi úti Telephelye" "Siófoki TK")
    ("Somogy Megyei Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Kollégium, Egységes Gyógypedagógiai Módszertani Intézmény Somogyvár Külterület (halastó és erdõ) Telephelye" "Siófoki TK")
    ("Somogy Megyei Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Kollégium, Egységes Gyógypedagógiai Módszertani Intézmény Somogyvár, Kossuth L. u. 9. Telephelye" "Siófoki TK")
    ("Somogyvári Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelés-Oktatást Végzõ Iskola, Kollégium, Egységes Gyógypedagógiai Módszertani Intézmény" "Siófoki TK")
    ("Szent László Király Általános Iskola Gamási Tagintézménye" "Siófoki TK")
    ("Tabi Takáts Gyula Általános Iskola és Alapfokú Mûvészeti Iskola" "Siófoki TK")
    ("Tabi Takáts Gyula Általános Iskola és Alapfokú Mûvészeti Iskola Tab , Kossuth utcai Telephelye" "Siófoki TK")
    ("Tabi Takáts Gyula Általános Iskola és Alapfokú Mûvészeti Iskola Tab , Templom téri Telephelye" "Siófoki TK")
    ("Törökkoppányi Általános Iskola" 	"Siófoki TK")
    ("Véssey Mihály Általános Iskola Telephelye" "Siófoki TK")
    ("Arany János Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Szakiskola és Készségfejlesztõ Iskola" "Soproni TK")
    ("Babos József Térségi Általános Iskola" "Soproni TK")
    ("Babos József Térségi Általános Iskola Agyagosszergényi Telephelye" "Soproni TK")
    ("Beledi Általános Iskola" "Soproni TK")
    ("Bõsárkányi Eötvös József Általános Iskola" "Soproni TK")
    ("Csornai Középiskolai Kollégium Telephelye" "Soproni TK")
    ("Deák Téri Általános Iskola" "Soproni TK")
    ("Doborjáni Ferenc Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Kollégium" "Soproni TK")
    ("Fertõszentmiklósi Felsõbüki Nagy Pál Általános Iskola Petõházi Tagiskolája" "Soproni TK")
    ("Fertõ-táj Általános Iskola 002-es telephelye" "Soproni TK")
    ("Horváth József Alapfokú Mûvészeti Iskola Telephelye" "Soproni TK")
    ("J. Haydn Alapfokú Mûvészeti Iskola" "Soproni TK")
    ("J. Haydn Alapfokú Mûvészeti Iskola Fertõszéplaki Telephelye" "Soproni TK")
    ("J. Haydn Alapfokú Mûvészeti Iskola Madách sétány 2. sz. Telephelye" "Soproni TK")
    ("J. Haydn Alapfokú Mûvészeti Iskola Mentes Mihály utcai II. sz. Telephelye" "Soproni TK")
    ("Kapuvár Térségi Általános Iskola" "Soproni TK")
    ("Kapuvár Térségi Általános Iskola 004. telephely" "Soproni TK")
    ("Kapuvár Térségi Általános Iskola Osli Telephelye" "Soproni TK")
    ("Kapuvár Térségi Általános Iskola Veszkényi Telephelye" "Soproni TK")
    ("Kerényi György Alapfokú Mûvészeti Iskola" "Soproni TK")
    ("Kerényi György Alapfokú Mûvészeti Iskola Csornai Telephelye" "Soproni TK")
    ("Kerényi György Alapfokú Mûvészeti Iskola Kóny, Rákóczi F. utcai telephelye" "Soproni TK")
    ("Király Iván Általános Iskola" "Soproni TK")
    ("Kónyi Deák Ferenc Általános Iskola Telephelye" "Soproni TK")
    ("Lackner Kristóf Általános Iskola Telephelye" "Soproni TK")
    ("Metrum Zenei Alapfokú Mûvészeti Iskola" "Soproni TK")
    ("Metrum Zenei Alapfokú Mûvészeti Iskola Ifjúság utcai telephelye" "Soproni TK")
    ("Mihályi Általános Iskola" "Soproni TK")
    ("Pantzer Gertrud Általános Iskola" "Soproni TK")
    ("Simonyi Károly Általános Iskola" "Soproni TK")
    ("Sopronhorpácsi Általános Iskola Fõ u. 5. sz. alatti telephelye" "Soproni TK")
    ("Soproni Kozmutza Flóra Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Szakiskola és Készségfejlesztõ Iskola" "Soproni TK")
    ("Soproni Petõfi Sándor Általános Iskola és Alapfokú Mûvészeti Iskola Balfi Tagiskolája" "Soproni TK")
    ("Soproni Petõfi Sándor Általános Iskola és Alapfokú Mûvészeti Iskola Ferenczy János Utcai Telephelye" "Soproni TK")
    ("Soproni Széchenyi István Gimnázium" "Soproni TK")
    ("Sopronkövesdi Általános Iskola Nagylózsi Telephelye" "Soproni TK")
    ("Szedenich Fülöp Általános Iskola" "Soproni TK")
    ("Szili Szent István Általános Iskola" 	"Soproni TK")
    ("Szili Szent István Általános Iskola Egyed Telephely" "Soproni TK")
    ("Tóth Antal Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Szakiskola, Kollégium" 	"Soproni TK")
    ("Ádám Jenõ Általános Iskola és Alapfokú Mûvészeti Iskola" "Szegedi TK")
    ("Béke Utcai Általános Iskola" "Szegedi TK")
    ("Csongrád-Csanád Vármegyei Pedagógiai Szakszolgálat" "Szegedi TK")
    ("Csongrád-Csanád Vármegyei Pedagógiai Szakszolgálat Hódmezõvásárhelyi Tagintézménye" "Szegedi TK")
    ("Csongrád-Csanád Vármegyei Pedagógiai Szakszolgálat Makói Tagintézménye" "Szegedi TK")
    ("Csongrád-Csanád Vármegyei Pedagógiai Szakszolgálat Szegedi Tagintézménye" "Szegedi TK")
    ("Domaszéki Bálint Sándor Általános Iskola és Alapfokú Mûvészeti Iskola" "Szegedi TK")
    ("Király-König Péter Zenei Alapfokú Mûvészeti Iskola" "Szegedi TK")
    ("Király-König Péter Zenei Alapfokú Mûvészeti Iskola Szeged, Herke Utcai Telephelye" "Szegedi TK")
    ("Király-König Péter Zenei Alapfokú Mûvészeti Iskola Szeged, Madách Utcai Telephelye" "Szegedi TK")
    ("Király-König Péter Zenei Alapfokú Mûvészeti Iskola Szeged, Mérey Utcai Telephelye" "Szegedi TK")
    ("Király-König Péter Zenei Alapfokú Mûvészeti Iskola Szeged,Építõ Utcai Telephelye" "Szegedi TK")
    ("Kisteleki Általános Iskola és Kollégium" "Szegedi TK")
    ("Mórahalmi Alapfokú Mûvészeti Iskola" "Szegedi TK")
    ("Mórahalmi Alapfokú Mûvészeti Iskola Mórahalom, Röszkei út 1.szám alatti Telephelye" "Szegedi TK")
    ("Mórahalmi Alapfokú Mûvészeti Iskola Röszke, Fõ utca 95.szám alatti Telephelye" "Szegedi TK")
    ("Rókusi Általános Iskola" "Szegedi TK")
    ("Ruzsai Weöres Sándor Általános Iskola és Alapfokú Mûvészeti Iskola" "Szegedi TK")
    ("Sándorfalvi Térségi Alapfokú Mûvészeti Iskola" "Szegedi TK")
    ("Szegedi Alsóvárosi Általános Iskola" "Szegedi TK")
    ("Szegedi Bárczi Gusztáv Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda és Általános Iskola" "Szegedi TK")
    ("Szegedi Bárczi Gusztáv Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda és Általános Iskola Szilléri Sugárúti Telephelye" "Szegedi TK")
    ("Szegedi Deák Ferenc Gimnázium" "Szegedi TK")
    ("Szegedi Eötvös József Gimnázium és Általános Iskola" "Szegedi TK")
    ("Szegedi Eötvös József Gimnázium és Általános Iskola Weöres Sándor Általános Iskolája" "Szegedi TK")
    ("Szegedi Gregor József Általános Iskola" "Szegedi TK")
    ("Szegedi Jerney János Általános Iskola" "Szegedi TK")
    ("Szegedi Kossuth Lajos Általános Iskola Deszki Zoltánfy István Általános Iskolája" "Szegedi TK")
    ("Szegedi Madách Imre Magyar-Angol Két Tanítási Nyelvû Általános Iskola" "Szegedi TK")
    ("Szegedi Petõfi Sándor Általános Iskola" "Szegedi TK")
    ("Szegedi Radnóti Miklós Kísérleti Gimnázium" "Szegedi TK")
    ("Szegedi Városi Kollégium" "Szegedi TK")
    ("Szegedi Városi Kollégium Fodor József Tagintézménye" "Szegedi TK")
    ("Szegedi Városi Kollégium Janikovszky Éva Tagintézménye" "Szegedi TK")
    ("Szegedi Zrínyi Ilona Általános Iskola" "Szegedi TK")
    ("Tarjáni Kéttannyelvû Általános Iskola és Alapfokú Mûvészeti Iskola" "Szegedi TK")
    ("Üllés, Forráskút, Csólyospálos Községi Általános Iskola és Alapfokú Mûvészeti Iskola" "Szegedi TK")
    ("Üllés, Forráskút, Csólyospálos Községi Általános Iskola és Alapfokú Mûvészeti Iskola Fontos Sándor Tagintézménye" "Szegedi TK")
    ("Zákányszéki Általános Iskola és Alapfokú Mûvészeti Iskola" "Szegedi TK")
    ("Arany János EGYMI Ezredéves Óvodája, Általános Iskolája, Készségfejlesztõ Iskolája és Fejlesztõ Nevelés-oktatást Végzõ Iskola Polgárdi Telephelye" "Székesfehérvári TK")
    ("Arany János EGYMI Velencei Dr. Ranschburg Jenõ Telephelye" "Székesfehérvári TK")
    ("Arany János Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelés-oktatást Végzõ Iskola és Egységes Gyógypedagógiai Módszertani Intézmény Budai úti Telephelye" "Székesfehérvári TK")
    ("Arany János Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelés-oktatást Végzõ Iskola és Egységes Gyógypedagógiai Módszertani Intézmény Óvoda Telephelye" "Székesfehérvári TK")
    ("Atilla Király Gimnázium és Általános Iskola" 	"Székesfehérvári TK")
    ("Atilla Király Gimnázium és Általános Iskola  Aba Sámuel Általános Iskolája" "Székesfehérvári TK")
    ("Batthyány Fülöp Általános Iskola" "Székesfehérvári TK")
    ("Batthyány Lajos Általános Iskola Géza Fejedelem Tagiskolája" "Székesfehérvári TK")
    ("Batthyány Lajos Általános Iskola Géza Fejedelem Tagiskolája Templom utca Telephely" "Székesfehérvári TK")
    ("Bicskei Csokonai Vitéz Mihály Általános Iskola Telephelye" "Székesfehérvári TK")
    ("Bicskei Prelúdium Alapfokú Mûvészeti Iskola" "Székesfehérvári TK")
    ("Bicskei Prelúdium Alapfokú Mûvészeti Iskola Árpád utca Telephelye" "Székesfehérvári TK")
    ("Bicskei Prelúdium Alapfokú Mûvészeti Iskola etyeki  Magyar utca telephelye" "Székesfehérvári TK")
    ("Bicskei Prelúdium Alapfokú Mûvészeti Iskola etyeki Kossuth utca 5. telephely" "Székesfehérvári TK")
    ("Bicskei Prelúdium Alapfokú Mûvészeti Iskola József Attila utca Telephelye" "Székesfehérvári TK")
    ("Bicskei Prelúdium Alapfokú Mûvészeti Iskola Prohászka Ottokár utca Telephelye" "Székesfehérvári TK")
    ("Bicskei Prelúdium Alapfokú Mûvészeti Iskola Szent István utcai telephelye" "Székesfehérvári TK")
    ("Bodajki Általános Iskola Telephelye" "Székesfehérvári TK")
    ("Chernel István Általános Iskola és Gimnázium Telephelye" "Székesfehérvári TK")
    ("Csóri Mátyás Király Általános Iskola" "Székesfehérvári TK")
    ("Dr. Kovács Pál Általános Iskola" 	"Székesfehérvári TK")
    ("Endresz György Általános Iskola" "Székesfehérvári TK")
    ("Esterházy Móric Nyelvoktató Német Nemzetiségi Általános Iskola Gánti Telephelye" "Székesfehérvári TK")
    ("Etyeki Nyelvoktató Német Nemzetiségi Általános Iskola" 	"Székesfehérvári TK")
    ("Fejér Vármegyei Pedagógiai Szakszolgálat" "Székesfehérvári TK")
    ("Fejér Vármegyei Pedagógiai Szakszolgálat Dunaújvárosi Tagintézménye" "Székesfehérvári TK")
    ("Fejér Vármegyei Pedagógiai Szakszolgálat Gárdonyi Tagintézménye" "Székesfehérvári TK")
    ("Fejér Vármegyei Pedagógiai Szakszolgálat Martonvásári Tagintézménye" "Székesfehérvári TK")
    ("Fejér Vármegyei Pedagógiai Szakszolgálat Móri Tagintézménye" "Székesfehérvári TK")
    ("Fejér Vármegyei Pedagógiai Szakszolgálat Székesfehérvári Tagintézménye" "Székesfehérvári TK")
    ("Felsõvárosi Általános Iskola" "Székesfehérvári TK")
    ("Gárdonyi Géza Általános Iskola" "Székesfehérvári TK")
    ("Hétvezér Általános Iskola" "Székesfehérvári TK")
    ("Kálozi Szent István Általános Iskola" "Székesfehérvári TK")
    ("Kápolnásnyéki Vörösmarty Mihály Általános Iskola és Gimnázium Telephelye" "Székesfehérvári TK")
    ("Lepsényi Fekete István Általános Iskola" 	"Székesfehérvári TK")
    ("Móri Dr. Zimmermann Ágoston Magyar-Angol Két Tanítási Nyelvû Általános Iskola" "Székesfehérvári TK")
    ("Móri Gárdonyi Géza, Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelés-Oktatást Végzõ Iskola, Egységes Gyógypedagógiai Módszertani Intézmény Bicskei Tagintézménye" "Székesfehérvári TK")
    ("Móri Pászti Miklós Alapfokú Mûvészeti Iskola Bakonycsernyei telephelye" "Székesfehérvári TK")
    ("Móri Pászti Miklós Alapfokú Mûvészeti Iskola Csókakõi telephelye" "Székesfehérvári TK")
    ("Móri Pászti Miklós Alapfokú Mûvészeti Iskola Kodály Zoltán utcai telephelye" "Székesfehérvári TK")
    ("Móri Pászti Miklós Alapfokú Mûvészeti Iskola Lovarda utca 7. Telephelye" "Székesfehérvári TK")
    ("Móri Petõfi Sándor Általános Iskola" "Székesfehérvári TK")
    ("Móri Petõfi Sándor Általános Iskola Ady Endre utcai Telephelye" "Székesfehérvári TK")
    ("Móri Radnóti Miklós Általános Iskola Károlyi József Tagiskolája" "Székesfehérvári TK")
    ("Móri Radnóti Miklós Általános Iskola Magyaralmási Tagiskolája" "Székesfehérvári TK")
    ("Móri Radnóti Miklós Általános Iskola Nádasdy Tamás Tagiskolája Csákberényi Telephelye" "Székesfehérvári TK")
    ("Nádasdladányi Nádasdy Ferenc Általános Iskola" "Székesfehérvári TK")
    ("Pákozdi Nemeskócsag Általános Iskola" "Székesfehérvári TK")
    ("Polgárdi Széchenyi István Általános Iskola Jenõ Andrássy utca 25. Telephelye" "Székesfehérvári TK")
    ("Sárszentmihályi Zichy Jenõ Általános Iskola" "Székesfehérvári TK")
    ("Sárvíz Alapfokú Mûvészeti Iskola Béke Téri Telephelye" "Székesfehérvári TK")
    ("Sárvíz Alapfokú Mûvészeti Iskola kálozi telephelye" "Székesfehérvári TK")
    ("Sárvíz Alapfokú Mûvészeti Iskola Szent István király Téri Telephelye" "Székesfehérvári TK")
    ("Székesfehérvári Hermann László Zenemûvészeti Szakgimnázium és Alapfokú Mûvészeti Iskola" "Székesfehérvári TK")
    ("Székesfehérvári Hermann László Zenemûvészeti Szakgimnázium és Alapfokú Mûvészeti Iskola Lepsényi Telephelye" "Székesfehérvári TK")
    ("Székesfehérvári Hermann László Zenemûvészeti Szakgimnázium és Alapfokú Mûvészeti Iskola Sziget utcai Telephelye" "Székesfehérvári TK")
    ("Székesfehérvári II. Rákóczi Ferenc Magyar-Angol Két Tanítási Nyelvû Általános Iskola Sárkeresztesi Telephelye" "Székesfehérvári TK")
    ("Székesfehérvári József Attila Középiskolai Kollégium" "Székesfehérvári TK")
    ("Székesfehérvári Kodály Zoltán Általános Iskola, Gimnázium és Alapfokú Mûvészeti Iskola" "Székesfehérvári TK")
    ("Székesfehérvári Kodály Zoltán Általános Iskola, Gimnázium és Alapfokú Mûvészeti Iskola Kápolnásnyéki Telephelye" "Székesfehérvári TK")
    ("Székesfehérvári Munkácsy Mihály Általános Iskola" "Székesfehérvári TK")
    ("Székesfehérvári Széna Téri Általános Iskola" "Székesfehérvári TK")
    ("Székesfehérvári Teleki Blanka Gimnázium és Általános Iskola" "Székesfehérvári TK")
    ("Székesfehérvári Vasvári Pál Általános Iskola" "Székesfehérvári TK")
    ("Székesfehérvári Vasvári Pál Gimnázium" "Székesfehérvári TK")
    ("Székesfehérvári Vörösmarty Mihály Általános Iskola Farkasvermi Úti Tagiskolája" "Székesfehérvári TK")
    ("Tóparti Gimnázium és Mûvészeti Szakgimnázium" "Székesfehérvári TK")
    ("Tóvárosi Általános Iskola" "Székesfehérvári TK")
    ("Zentai Úti Általános Iskola" "Székesfehérvári TK")
    ("Bátai Hunyadi János Általános Iskola" "Szekszárdi TK")
    ("Bátaszéki Kanizsai Dorottya Általános Iskola" "Szekszárdi TK")
    ("Bátaszéki Kanizsai Dorottya Általános Iskola Pörbölyi Telephelye" "Szekszárdi TK")
    ("Bogyiszlói Általános Iskola" "Szekszárdi TK")
    ("Bölcskei Kegyes József Általános Iskola" 	"Szekszárdi TK")
    ("Dunaföldvári Beszédes József Általános Iskola Jókai utcai telephelye" "Szekszárdi TK")
    ("Dunaföldvári Magyar László Gimnázium" "Szekszárdi TK")
    ("Faddi Gárdonyi Géza Általános Iskola" "Szekszárdi TK")
    ("Kölesdi Béri Balogh Ádám Általános Iskola" "Szekszárdi TK")
    ("Nagydorogi Széchényi Sándor Általános Iskola Kajdacsi Általános Iskolája" "Szekszárdi TK")
    ("Õcsényi Perczel Mór Általános Iskola" "Szekszárdi TK")
    ("Õcsényi Perczel Mór Általános Iskola Tornaterem" "Szekszárdi TK")
    ("Paksi Deák Ferenc Általános Iskola" "Szekszárdi TK")
    ("Paksi II. Rákóczi Ferenc Általános Iskola" "Szekszárdi TK")
    ("Pro Artis Alapfokú Mûvészeti Iskola" "Szekszárdi TK")
    ("Pro Artis Alapfokú Mûvészeti Iskola Sárdy János Tagintézménye" "Szekszárdi TK")
    ("PRO ARTIS Alapfokú Mûvészetoktatási Intézmény, Nagydorogi telephelye" "Szekszárdi TK")
    ("Szekszárdi Baka István Általános Iskola" "Szekszárdi TK")
    ("Szekszárdi Egységes Gyógypedagógiai Módszertani Intézmény Gazdag Erzsi Általános Iskolája, Fejlesztõ Nevelés-Oktatást Végzõ Iskolája és Kollégiuma" "Szekszárdi TK")
    ("Szekszárdi Garay János Általános Iskola Sióagárdi Tagintézménye" "Szekszárdi TK")
    ("Szekszárdi I. Béla Gimnázium Bezerédj István Általános Iskolája" "Szekszárdi TK")
    ("Szekszárdi I. Béla Gimnázium, Kollégium és Általános Iskola" "Szekszárdi TK")
    ("Szekszárdi Liszt Ferenc Alapfokú Mûvészeti Iskola Bátaszéki Tagintézménye" "Szekszárdi TK")
    ("Szekszárdi Liszt Ferenc Alapfokú Mûvészeti Iskola Béri Balogh utcai telephelye" "Szekszárdi TK")
    ("Szekszárdi Liszt Ferenc Alapfokú Mûvészeti Iskola Fusz János Tagintézménye" "Szekszárdi TK")
    ("Szekszárdi Liszt Ferenc Alapfokú Mûvészeti Iskola Sióagárdi telephelye" "Szekszárdi TK")
    ("Szekszárdi Liszt Ferenc Alapfokú Mûvészeti Iskola Zrínyi utcai telephelye" "Szekszárdi TK")
    ("Szekszárdi Óvoda, Általános Iskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelés-Oktatást Végzõ Iskola, Kollégium, Egységes Gyógypedagógiai Módszertani Intézmény telephelye" "Szekszárdi TK")
    ("Tolna Vármegyei Pedagógiai Szakszolgálat Bonyhádi Tagintézménye" "Szekszárdi TK")
    ("Tolna Vármegyei Pedagógiai Szakszolgálat Paksi Tagintézménye" "Szekszárdi TK")
    ("Tolna Vármegyei Pedagógiai Szakszolgálat Tamási Tagintézménye" "Szekszárdi TK")
    ("Várdomb-Alsónána Általános Iskola" "Szekszárdi TK")
    ("Várdomb-Alsónána Általános Iskola Várdombi Telephelye" "Szekszárdi TK")
    ("Wosinsky Mór Általános Iskola Eötvös utcai telephelye" "Szekszárdi TK")
    ("Wosinsky Mór Általános Iskola Sport utcai telephelye" "Szekszárdi TK")
    ("Wosinsky Mór Általános Iskola Széchenyi István Tagiskolája Kossuth utcai telephelye" "Szekszárdi TK")
    ("Baktakéki Körzeti Általános Iskola" "Szerencsi TK")
    ("Bekecsi II. Rákóczi Ferenc Informatikai és Matematikai Általános Iskola és Szakgimnázium" "Szerencsi TK")
    ("Bodrogkeresztúri Eötvös József Általános Iskola" "Szerencsi TK")
    ("Csobaji Általános Iskola" "Szerencsi TK")
    ("Encsi Váci Mihály Gimnázium és Kollégium" "Szerencsi TK")
    ("Encsi Zrínyi Ilona Általános Iskola" "Szerencsi TK")
    ("Encsi Zrínyi Ilona Általános Iskola Csobádi Tagintézménye" "Szerencsi TK")
    ("Felsõvadászi II. Rákóczi Ferenc Általános Iskola" "Szerencsi TK")
    ("Fogarasi János Általános Iskola Léhi Telephelye" "Szerencsi TK")
    ("Forrói Gárdonyi Géza Általános Iskola" "Szerencsi TK")
    ("Halmaji Gárdonyi Géza Általános Iskola" "Szerencsi TK")
    ("Hernádvécsei Körzeti Általános iskola" "Szerencsi TK")
    ("Koroknay Dániel Tehetséggondozó Általános Iskola" "Szerencsi TK")
    ("Legyesbényei Zalay Andor Általános Iskola Rákóczi Úti Telephelye" "Szerencsi TK")
    ("Megyaszói Mészáros Lõrinc Körzeti Általános Iskola Alsódobszai Telephelye" "Szerencsi TK")
    ("Monoki Kossuth Lajos Általános Iskola" "Szerencsi TK")
    ("Novajidrányi Kölcsey Ferenc Általános Iskola Garadnai Tagintézménye" "Szerencsi TK")
    ("Prügyi Móricz Zsigmond Általános Iskola" "Szerencsi TK")
    ("Szalaszendi Körzeti Általános Iskola" "Szerencsi TK")
    ("Szemerei Általános Iskola" "Szerencsi TK")
    ("Szerencsi Középiskolai Kollégium" "Szerencsi TK")
    ("Szikszói Móricz Zsigmond Általános Iskola" "Szerencsi TK")
    ("Taktakenézi Petõfi Sándor Általános Iskola" "Szerencsi TK")
    ("Tarcali Klapka György Általános Iskola" "Szerencsi TK")
    ("Térségi Alapfokú Mûvészeti Iskola" "Szerencsi TK")
    ("Térségi Alapfokú Mûvészeti Iskola" "Szerencsi TK")
    ("Térségi Alapfokú Mûvészeti Iskola" "Szerencsi TK")
    ("Térségi Alapfokú Mûvészeti Iskola" "Szerencsi TK")
    ("Térségi Alapfokú Mûvészeti Iskola" "Szerencsi TK")
    ("Térségi Alapfokú Mûvészeti Iskola" "Szerencsi TK")
    ("Térségi Alapfokú Mûvészeti Iskola" "Szerencsi TK")
    ("Térségi Alapfokú Mûvészeti Iskola" "Szerencsi TK")
    ("Térségi Alapfokú Mûvészeti Iskola" 	"Szerencsi TK")
    ("Tiszalúci Arany János Általános Iskola" "Szerencsi TK")
    ("Tokaji Egységes Gyógypedagógiai  Módszertani Intézmény" "Szerencsi TK")
    ("Tokaji II. Rákóczi Ferenc Tehetséggondozó Általános Iskola" "Szerencsi TK")
    ("Zempléni Árpád Általános Iskola" "Szerencsi TK")
    ("Szárny-nyitogató Alapfokú Mûvészeti Iskola Szigetújfalu Telephelye" "Szigetszentmiklósi TK")
    ("Szárny-nyitogató Alapfokú Mûvészeti Iskola Tököl, Kossuth Lajos utcai Telephelye" "Szigetszentmiklósi TK")
    ("Baktay Ervin Gimnázium" "Szigetszentmiklósi TK")
    ("Dezsõ Lajos Alapfokú Mûvészeti Iskola" "Szigetszentmiklósi TK")
    ("Dezsõ Lajos Alapfokú Mûvészeti Iskola Béke téri telephelye" "Szigetszentmiklósi TK")
    ("Dezsõ Lajos Alapfokú Mûvészeti Iskola Szigetbecsei Telephelye" "Szigetszentmiklósi TK")
    ("Dömsödi Széchenyi István Általános Iskola Arany János Általános Iskolája" "Szigetszentmiklósi TK")
    ("Dunaharaszti Alapfokú Mûvészeti Iskola" "Szigetszentmiklósi TK")
    ("Dunaharaszti Alapfokú Mûvészeti Iskola Földvári utcai Telephely" "Szigetszentmiklósi TK")
    ("Dunaharaszti Alapfokú Mûvészeti Iskola Táncsics Mihály utcai Telephely" "Szigetszentmiklósi TK")
    ("Dunaharaszti Hunyadi János Német Nemzetiségi Általános Iskola Fõ út 154-156. Telephely" "Szigetszentmiklósi TK")
    ("Dunaharaszti Hunyadi János Német Nemzetiségi Általános Iskola Fõ út 69. Telephely" "Szigetszentmiklósi TK")
    ("Dunaharaszti II. Rákóczi Ferenc Általános Iskola Rákóczi utca 1. Alatti Telephelye" "Szigetszentmiklósi TK")
    ("Dunavarsányi Árpád Fejedelem Általános Iskola" "Szigetszentmiklósi TK")
    ("Dunavarsányi Árpád Fejedelem Általános Iskola Kossuth Lajos utca 33.alatti Telephelye" "Szigetszentmiklósi TK")
    ("Dunavarsányi Erkel Ferenc Alapfokú Mûvészeti Iskola" "Szigetszentmiklósi TK")
    ("Dunavarsányi Erkel Ferenc Alapfokú Mûvészeti Iskola Dunavarsány Kossuth Lajos utcai Telephelye" "Szigetszentmiklósi TK")
    ("Dunavarsányi Erkel Ferenc Alapfokú Mûvészeti Iskola Szigethalom, József Attila Utcai Telephelye" "Szigetszentmiklósi TK")
    ("Dunavarsányi Erkel Ferenc Alapfokú Mûvészeti Iskola szigethalom, Thököly Utcai telephelye" "Szigetszentmiklósi TK")
    ("Kardos István Általános Iskola és Gimnázium" "Szigetszentmiklósi TK")
    ("Kiskunlacházi Általános Iskola Gárdonyi utcai Telephelye" "Szigetszentmiklósi TK")
    ("Ráckevei Ady Endre Gimnázium" "Szigetszentmiklósi TK")
    ("Ráckevei Árpád Fejedelem Általános Iskola Telephelye" "Szigetszentmiklósi TK")
    ("Ránki György Alapfokú Mûvészeti iskola Kossuth Lajos utca 51. szám alatti telephelye" "Szigetszentmiklósi TK")
    ("Ránki György Alapfokú Mûvészeti Iskola Szent István tér 22. szám alatti telephelye" "Szigetszentmiklósi TK")
    ("Ránki György Alapfokú Mûvészeti Iskola Szigetszentmártoni Telephelye" "Szigetszentmiklósi TK")
    ("Szigetbecse-Makád Általános Iskola Thúry József Általános Iskolája" "Szigetszentmiklósi TK")
    ("Szigethalmi Széchenyi István Általános Iskola" "Szigetszentmiklósi TK")
    ("Szigethalmi Szent István Általános Iskola" "Szigetszentmiklósi TK")
    ("Szigetszentmiklós Ádám Jenõ Általános Iskola és Alapfokú Mûvészeti Iskola Kossuth Lajos Utcai Telephelye" "Szigetszentmiklósi TK")
    ("Szigetszentmiklósi Ádám Jenõ Általános Iskola és Alapfokú Mûvészeti Iskola Csokonai Utcai Telephelye" "Szigetszentmiklósi TK")
    ("Szigetszentmiklósi Ádám Jenõ Általános Iskola és Alapfokú Mûvészeti Iskola Temesvári utcai Telephelye" "Szigetszentmiklósi TK")
    ("Szigetszentmiklósi Batthyány Kázmér Gimnázium" "Szigetszentmiklósi TK")
    ("Szigetszentmiklósi Bíró Lajos Általános Iskola Kossuth Lajos utcai Telephelye" "Szigetszentmiklósi TK")
    ("Szigetszentmiklósi József Attila Általános Iskola" "Szigetszentmiklósi TK")
    ("Szigetszentmiklósi Konduktív Óvoda, Általános Iskola és Egységes Gyógypedagógiai Módszertani Intézmény" "Szigetszentmiklósi TK")
    ("Szigetszentmiklósi Konduktív Óvoda, Általános Iskola és Egységes Gyógypedagógiai Módszertani Intézmény Fejlesztõ nevelés-oktatás" "Szigetszentmiklósi TK")
    ("Szigetszentmiklósi Temesvári Utcai Általános Iskola" "Szigetszentmiklósi TK")
    ("Tököli Weöres Sándor Általános Iskola" "Szigetszentmiklósi TK")
    ("Volly István Alapfokú Mûvészeti Iskola" "Szigetszentmiklósi TK")
    ("Volly István Alapfokú Mûvészeti Iskola Délegyházi Telephelye" "Szigetszentmiklósi TK")
    ("Volly István Alapfokú Mûvészeti Iskola Majosházi Telephelye" "Szigetszentmiklósi TK")
    ("Volly István Alapfokú Mûvészeti Iskola Szigetújfalui Telephelye" "Szigetszentmiklósi TK")
    ("Almamellék-Somogyhárságyi Általános Iskola és Kollégium" "Szigetvári TK")
    ("Baksai Általános Iskola" "Szigetvári TK")
    ("Dél-Zselic Tinódi Lantos Sebestyén Általános Iskola" "Szigetvári TK")
    ("Dencsháza-Hobol Általános Iskola" "Szigetvári TK")
    ("Drávasztárai Általános Iskola" "Szigetvári TK")
    ("Istvánffy Miklós Általános Iskola" "Szigetvári TK")
    ("Királyegyházai Általános Iskola" "Szigetvári TK")
    ("Kiss Géza Magyar-Horvát Kétnyelvû Nemzetiségi Általános Iskola" 	"Szigetvári TK")
    ("Mágocsi Általános Iskola és Alapfokú Mûvészeti Iskola" "Szigetvári TK")
    ("Magyarmecskei Általános Iskola Telephelye" "Szigetvári TK")
    ("Mindszentgodisai Általános Iskola Telephelye" "Szigetvári TK")
    ("Nagypeterdi Általános Iskola" "Szigetvári TK")
    ("Sásdi Általános Iskola" "Szigetvári TK")
    ("Somogyapáti Általános Iskola Telephelye" "Szigetvári TK")
    ("Szentlõrinci Általános Iskola Bicsérdi Általános Iskola Tagintézménye" "Szigetvári TK")
    ("Szentlõrinci Általános Iskola Bükkösdi Általános Iskola Tagintézményének Telephelye" "Szigetvári TK")
    ("Szentlõrinci Általános Iskola Hetvehelyi Általános Iskola Kossuth utcai Telephelye" "Szigetvári TK")
    ("Szentlõrinci Általános Iskola Királyegyházai Telephelye" "Szigetvári TK")
    ("Szentlõrinci Általános Iskola Zsigmond Király Általános Iskola Tagintézményének Telephelye" "Szigetvári TK")
    ("Szigetvári Weiner Leó Alapfokú Mûvészeti Iskola" "Szigetvári TK")
    ("Szigetvári Weiner Leó Alapfokú Mûvészeti Iskola Kétújfalui Telephelye" "Szigetvári TK")
    ("Szigetvári Weiner Leó Alapfokú Mûvészeti Iskola Nagypeterdi Telephelye" "Szigetvári TK")
    ("Szigetvári Weiner Leó Alapfokú Mûvészeti Iskola Sellyei Telephelye" "Szigetvári TK")
    ("Szigetvári Weiner Leó Alapfokú Mûvészeti Iskola Szent István lakótelepi Telephelye" "Szigetvári TK")
    ("Vajszlói Kodolányi János Általános Iskola Bogádmindszenti Általános Iskolája" "Szigetvári TK")
    ("Chiovini Ferenc  Általános Iskola és Alapfokú Mûvészeti Iskola Tiszasülyi Tagintézménye" "Szolnoki TK")
    ("Chiovini Ferenc Általános Iskola és Alapfokú Mûvészeti Iskola Besenyszögi Telephelye" "Szolnoki TK")
    ("Cibakházi Damjanich János Általános Iskola Czibak Imre Téri Telephelye" "Szolnoki TK")
    ("Cibakházi Damjanich János Általános Iskola Szabadság Téri Telephelye" "Szolnoki TK")
    ("Cserkeszõlõi Petõfi Sándor Általános Iskola" "Szolnoki TK")
    ("Hajnóczy József Gimnázium, Humán Szakgimnázium és Kollégium" "Szolnoki TK")
    ("Homoki Általános Iskola" "Szolnoki TK")
    ("Jász-Nagykun-Szolnok Vármegyei Pedagógiai Szakszolgálat" "Szolnoki TK")
    ("Jász-Nagykun-Szolnok Vármegyei Pedagógiai Szakszolgálat Jászberényi Tagintézménye" "Szolnoki TK")
    ("Jász-Nagykun-Szolnok Vármegyei Pedagógiai Szakszolgálat Karcagi Tagintézménye" "Szolnoki TK")
    ("Jász-Nagykun-Szolnok Vármegyei Pedagógiai Szakszolgálat Kunszentmártoni Tagintézmény Tiszaföldvári Telephelye" "Szolnoki TK")
    ("Jász-Nagykun-Szolnok Vármegyei Pedagógiai Szakszolgálat Mezõtúri Tagintézménye" "Szolnoki TK")
    ("Jász-Nagykun-Szolnok Vármegyei Pedagógiai Szakszolgálat Szolnoki Tagintézmény Újszászi Telephelye" "Szolnoki TK")
    ("Jász-Nagykun-Szolnok Vármegyei Pedagógiai Szakszolgálat Tiszafüredi Tagintézménye" "Szolnoki TK")
    ("Jász-Nagykun-Szolnok Vármegyei Pedagógiai Szakszolgálat Törökszentmiklósi Tagintézménye" "Szolnoki TK")
    ("Kunszentmártoni Általános Iskola és Alapfokú Mûvészeti Iskola" "Szolnoki TK")
    ("Kunszentmártoni Általános Iskola és Alapfokú Mûvészeti Iskola Széchenyi lakótelepi telephelye" "Szolnoki TK")
    ("Liget Úti EGYMI Autizmus Centrum Telephelye" "Szolnoki TK")
    ("Martfûi József Attila Általános Iskola" "Szolnoki TK")
    ("Öcsödi József Attila Általános Iskola Deák Ferenc úti Telephelye" "Szolnoki TK")
    ("Öcsödi József Attila Általános Iskola Köztársaság úti Telephelye" "Szolnoki TK")
    ("Rákóczifalvai II. Rákóczi Ferenc Általános Iskola és Alapfokú Mûvészeti Iskola" "Szolnoki TK")
    ("Révay György EGYMI Telephelye" "Szolnoki TK")
    ("Szajoli Kölcsey Ferenc Általános Iskola" "Szolnoki TK")
    ("Széchenyi Körúti Sportiskolai Általános Iskola és Alapfokú Mûvészeti Iskola" "Szolnoki TK")
    ("Széchenyi Körúti Sportiskolai Általános Iskola és Alapfokú Mûvészeti Iskola Rákóczi Úti Telephelye" "Szolnoki TK")
    ("Szegõ Gábor Általános Iskola" "Szolnoki TK")
    ("Szolnok Városi Tehetséggondozó Szakkollégium Bán Úti Tagintézménye" "Szolnoki TK")
    ("Szolnoki Bartók Béla Alapfokú Mûvészeti Iskola" "Szolnoki TK")
    ("Szolnoki Bartók Béla Alapfokú Mûvészeti Iskola Simon Ferenc Utcai Telephelye" "Szolnoki TK")
    ("Szolnoki Bartók Béla Alapfokú Mûvészeti Iskola Újszászi Telephelye" "Szolnoki TK")
    ("Szolnoki II. Rákóczi Ferenc Magyar-Német Két Tanítási Nyelvû Általános Iskola" "Szolnoki TK")
    ("Szolnoki Kõrösi Csoma Sándor Általános Iskola és Alapfokú Mûvészeti Iskola" "Szolnoki TK")
    ("Szolnoki Széchenyi István Gimnázium és Mûvészeti Szakgimnázium" "Szolnoki TK")
    ("Szolnoki Széchenyi István Gimnázium és Mûvészeti Szakgimnázium Telephelye" "Szolnoki TK")
    ("Tiszaföldvári Kossuth Lajos Általános Iskola" "Szolnoki TK")
    ("Tiszakürti Körzeti Általános Iskola Petõfi Sándor Tagintézménye" "Szolnoki TK")
    ("Tószegi Általános Iskola Endre Király Tagintézménye" "Szolnoki TK")
    ("Tószegi Általános Iskola Endre Király Tagintézménye Tornaterem" "Szolnoki TK")
    ("Újszászi Vörösmarty Mihály Általános Iskola" "Szolnoki TK")
    ("Varga Katalin Gimnázium telephelye" "Szolnoki TK")
    ("Zagyvarékasi Damjanich János Általános Iskola" "Szolnoki TK")
    ("Apponyi Albert Általános Iskola" "Szombathelyi TK")
    ("Aranyhíd Egységes Gyógypedagógiai, Konduktív Pedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola és Fejlesztõ Nevelés-Oktatást Végzõ Iskola" "Szombathelyi TK")
    ("Csehimindszenti Mindszenty József Általános Iskola" "Szombathelyi TK")
    ("Dési Huber István Általános Iskola" "Szombathelyi TK")
    ("Felsõcsatári Nyelvoktató Nemzetiségi Általános Iskola" "Szombathelyi TK")
    ("Gothard Jenõ Általános Iskola" "Szombathelyi TK")
    ("Hatos Ferenc Általános Iskola és Alapfokú Mûvészeti Iskola" "Szombathelyi TK")
    ("Körmendi Alapfokú Zene- és Táncmûvészeti Iskola" "Szombathelyi TK")
    ("Körmendi Alapfokú Zene- és Táncmûvészeti Iskola Csákánydoroszló, Vasút utca 31.sz. alatti Telephelye" "Szombathelyi TK")
    ("Körmendi Kölcsey Ferenc Gimnázium" "Szombathelyi TK")
    ("Németh Pál Kollégium" "Szombathelyi TK")
    ("Oladi Általános Iskola" "Szombathelyi TK")
    ("Olcsai-Kiss Zoltán Általános Iskola Somogyi Béla Tagiskolája" "Szombathelyi TK")
    ("Õriszentpéteri Általános Iskola Pankaszi Telephelye" "Szombathelyi TK")
    ("Paragvári Utcai Általános Iskola" "Szombathelyi TK")
    ("Prinz Gyula Általános Iskola" "Szombathelyi TK")
    ("Rumi Rajki István Általános Iskola" "Szombathelyi TK")
    ("Sorkifaludi Gárdonyi Géza Általános Iskola" "Szombathelyi TK")
    ("Szentpéterfai Horvát-Magyar Kétnyelvû Nemzetiségi Általános Iskola" "Szombathelyi TK")
    ("Szombathelyi Bartók Béla Zenei Alapfokú Mûvészeti Iskola Bolyai János utcai Telephelye" "Szombathelyi TK")
    ("Szombathelyi Bartók Béla Zenei Alapfokú Mûvészeti Iskola Gencsapáti telephelye" "Szombathelyi TK")
    ("Szombathelyi Bartók Béla Zenei Alapfokú Mûvészeti Iskola Losonc Utcai Telephelye" "Szombathelyi TK")
    ("Szombathelyi Bartók Béla Zenei Alapfokú Mûvészeti Iskola Rákóczi Ferenc utcai telephelye" "Szombathelyi TK")
    ("Szombathelyi Bartók Béla zenei Alapfokú Mûvészeti Iskola Váci Mihály utcai telephelye" "Szombathelyi TK")
    ("Szombathelyi Bartók Béla Zenei Alapfokú Mûvészeti Iskola Váti Telephelye" "Szombathelyi TK")
    ("Szombathelyi Bartók Béla Zeneiskola- Alapfokú Mûvészeti Iskola Bercsényi Miklós utcai Telephelye" "Szombathelyi TK")
    ("Szombathelyi Bartók Béla Zeneiskola Jáki Telephelye" "Szombathelyi TK")
    ("Szombathelyi Bartók Béla Zeneiskola-Alapfokú Mûvészeti Iskola" "Szombathelyi TK")
    ("Szombathelyi Derkovits Gyula Általános Iskola" "Szombathelyi TK")
    ("Szombathelyi Mûvészeti Szakgimnázium és Technikum" "Szombathelyi TK")
    ("Szombathelyi Neumann János Általános Iskola" "Szombathelyi TK")
    ("Szombathelyi Zrínyi Ilona Általános Iskola" "Szombathelyi TK")
    ("Takács Jenõ Alapfokú Mûvészeti Iskola" "Szombathelyi TK")
    ("Takács Jenõ Alapfokú Mûvészeti Iskola Õriszentpéter, Kovácsszer 7. alatti telephelye" "Szombathelyi TK")
    ("Takács Jenõ Alapfokú Mûvészeti Iskola Szentgotthárd, Füzesi Utcai Telephelye" "Szombathelyi TK")
    ("Táplánszentkereszti Apáczai Csere János Általános Iskola" 	"Szombathelyi TK")
    ("Táplánszentkereszti Apáczai Csere János Általános Iskola Váti Tagintézménye" "Szombathelyi TK")
    ("Vas Vármegyei Pedagógiai Szakszolgálat" "Szombathelyi TK")
    ("Vas Vármegyei Pedagógiai Szakszolgálat Körmendi Tagintézménye" "Szombathelyi TK")
    ("Vas Vármegyei Pedagógiai Szakszolgálat Kõszegi Tagintézménye" "Szombathelyi TK")
    ("Vas Vármegyei Pedagógiai Szakszolgálat Szentgotthárdi Tagintézménye" "Szombathelyi TK")
    ("Vas Vármegyei Pedagógiai Szakszolgálat Szombathelyi Tagintézménye Paragvári utcai Telephelye" "Szombathelyi TK")
    ("Vasvári Általános Iskola" 	"Szombathelyi TK")
    ("Vasvári Zenei Alapfokú Mûvészeti Iskola" "Szombathelyi TK")
    ("Vasvári Zenei Alapfokú Mûvészeti Iskola - Rábahídvégi Telephely" "Szombathelyi TK")
    ("Aparhanti Általános Iskola" "Tamási TK")
    ("Bonyhádi Általános Iskola Bartók Béla Alapfokú Mûvészeti Iskolája" "Tamási TK")
    ("Bonyhádi Általános Iskola, Gimnázium és Alapfokú Mûvészeti Iskola" "Tamási TK")
    ("Cikói Perczel Mór Általános Iskola Petõfi Sándor utcai Telephelye" "Tamási TK")
    ("Dombóvári Illyés Gyula Gimnázium Tornacsarnoka" "Tamási TK")
    ("Dombóvári József Attila Általános Iskola Attalai Telephelye" "Tamási TK")
    ("Györei Templom Általános Iskola" "Tamási TK")
    ("Hõgyészi Hegyhát Általános Iskola és Gimnázium Tolnai Lajos Gimnáziumi és Kollégiumi Tagintézménye" "Tamási TK")
    ("Hõgyészi Hegyhát Általános Iskola, Gimnázium és Kollégium" "Tamási TK")
    ("Iregszemcsei Deák Ferenc Általános Iskola Felsõnyéki Tagiskolája" "Tamási TK")
    ("Iregszemcsei Deák Ferenc Általános Iskola Magyarkeszi Tagiskolája Telephelye" "Tamási TK")
    ("Kaposszekcsõi Általános Iskola Csikóstõttõsi telephelye" "Tamási TK")
    ("Kurdi Körzeti Általános Iskola Döbröközi Általános Iskolája" "Tamási TK")
    ("Mórágyi Általános Iskola" "Tamási TK")
    ("Nagymányoki II. Rákóczi Ferenc Általános Iskola és Alapfokú Mûvészeti Iskola" "Tamási TK")
    ("Szakcsi Általános Iskola" "Tamási TK")
    ("Tamási Egységes Gyógypedagógiai Módszertani Intézmény Berkes János Általános Iskolája, Készségfejlesztõ Iskolája, Fejlesztõ Nevelés-Oktatást Végzõ Iskolája és Kollégiuma" "Tamási TK")
    ("Tamási Egységes Gyógypedagógiai Módszertani Intézmény Móra Ferenc Általános Iskolájának Telephelye" "Tamási TK")
    ("Teveli Általános Iskola" "Tamási TK")
    ("Vak Bottyán Általános Iskola és Gimnázium Nagyszékelyi Telephelye" "Tamási TK")
    ("Vak Bottyán Általános Iskola és Gimnázium Pálfai Általános Iskolájának Kossuth Lajos utcai Telephelye" "Tamási TK")
    ("Vak Bottyán Általános Iskola és Gimnázium telephelye - Sportcsarnok" "Tamási TK")
    ("Vak Bottyán Általános Iskola és Gimnázium Vörösmarty Mihály Általános Iskolájának telephelye - Könyvtár" "Tamási TK")
    ("Würtz Ádám Általános Iskola Döbröközi Telephelye" "Tamási TK")
    ("Würtz Ádám Általános Iskola és Alapfokú Mûvészeti Iskola Regölyi Telephelye" "Tamási TK")
    ("Würtz Ádám Általános Iskola Iregszemcsei Telephelye" "Tamási TK")
    ("Würtz Ádám Általános Iskola Szakályi Tagiskolája" "Tamási TK")
    ("Würtz Ádám Általános Iskola Tamási Lajos Tagiskolája" "Tamási TK")
    ("Zombai Általános Iskola Felsõnánai Telephelye" "Tamási TK")
    ("Zombai Általános Iskola Tengelici Tagiskolája" "Tamási TK")
    ("Almásfüzitõi Fekete István Általános Iskola" "Tatabányai TK")
    ("Ászári Jászai Mari Általános Iskola" "Tatabányai TK")
    ("Bakfark Bálint Alapfokú Mûvészeti Iskola" "Tatabányai TK")
    ("Bakfark Bálint Alapfokú Mûvészeti Iskola Császári telephelye" "Tatabányai TK")
    ("Bakfark Bálint Alapfokú Mûvészeti Iskola Kecskédi telephelye" "Tatabányai TK")
    ("Bakonysárkányi Fekete István Általános Iskola" "Tatabányai TK")
    ("Bakonyszombathelyi Benedek Elek Általános Iskola" "Tatabányai TK")
    ("Benedek Elek Óvoda, Általános Iskola, Fejlesztõ Nevelés-Oktatást Végzõ Iskola, Egységes Gyógypedagógiai Módszertani Intézmény" "Tatabányai TK")
    ("Császári Zrínyi Ilona Általános Iskola" "Tatabányai TK")
    ("Dózsakerti Váci Mihály Általános Iskola Dózsa György Sportiskolai Általános Iskolája" "Tatabányai TK")
    ("Eötvös József Gimnázium és Kollégium" "Tatabányai TK")
    ("Feszty Árpád Általános Iskola" "Tatabányai TK")
    ("Gyermelyi Általános Iskola" "Tatabányai TK")
    ("Kecskédi Német Nemzetiségi Általános Iskola" "Tatabányai TK")
    ("Kertvárosi Általános Iskola Hadsereg utcai telephelye" "Tatabányai TK")
    ("Kézdi-Vásárhelyi Imre Általános Iskola" "Tatabányai TK")
    ("Kisbéri Táncsics Mihály Gimnázium és Általános Iskola Petõfi Sándor Általános Iskolája" "Tatabányai TK")
    ("Kisfaludy Mihály Általános Iskola és Alapfokú Mûvészeti Iskola" "Tatabányai TK")
    ("Kodály Zoltán Általános Iskola és Alapfokú Mûvészeti Iskola Herman Ottó Általános Iskolája" "Tatabányai TK")
    ("Komárom- Esztergom Vármegyei Pedagógiai Szakszolgálat Komáromi Tagintézmény Telephelye" "Tatabányai TK")
    ("Komárom-Esztergom Vármegyei Pedagógiai Szakszolgálat Esztergomi Tagintézménye" "Tatabányai TK")
    ("Komárom-Esztergom Vármegyei Pedagógiai Szakszolgálat Esztergomi Tagintézményének Nyergesújfalui Telephelye" "Tatabányai TK")
    ("Komárom-Esztergom Vármegyei Pedagógiai Szakszolgálat Komáromi Tagintézménye" "Tatabányai TK")
    ("Komárom-Esztergom Vármegyei Pedagógiai Szakszolgálat Tatabányai Tagintézménye" "Tatabányai TK")
    ("Komárom-Esztergom Vármegyei Pedagógiai Szakszolgálat Tatai Tagintézménye Bartók Béla úti telephelye" "Tatabányai TK")
    ("Komáromi Egressy Béni Alapfokú Mûvészeti Iskola" "Tatabányai TK")
    ("Komáromi Jókai Mór Gimnázium" "Tatabányai TK")
    ("Komáromi Petõfi Sándor Általános Iskola" "Tatabányai TK")
    ("Kõkúti Általános Iskola" "Tatabányai TK")
    ("Menner Bernát Alapfokú Mûvészeti Iskola" "Tatabányai TK")
    ("Menner Bernát Alapfokú Mûvészeti Iskola Bartók Béla utcai Telephelye" "Tatabányai TK")
    ("Menner Bernát Alapfokú Mûvészeti Iskola Kocsi Telephelye" "Tatabányai TK")
    ("Menner Bernát Alapfokú Mûvészeti Iskola Országgyûlés téri Telephelye" "Tatabányai TK")
    ("Menner Bernát Alapfokú Mûvészeti Iskola Tardosi Telephelye" "Tatabányai TK")
    ("Nagyigmándi Pápay József Általános Iskola" 	"Tatabányai TK")
    ("Oroszlányi József Attila Általános Iskola" "Tatabányai TK")
    ("Óvárosi Általános Iskola Béke utcai Telephelye" "Tatabányai TK")
    ("Pólya György Általános Iskola Esztergomi úti Telephelye" "Tatabányai TK")
    ("Súri Arany János Általános Iskola" "Tatabányai TK")
    ("Szákszendi Öveges József Általános Iskola" "Tatabányai TK")
    ("Szõnyi Bozsik József Általános Iskola" "Tatabányai TK")
    ("Tárkányi Általános Iskola" "Tatabányai TK")
    ("Tatabányai Éltes Mátyás Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Szakiskola és Készségfejlesztõ Iskola Jászai Mari utcai telephelye" "Tatabányai TK")
    ("Tatabányai Éltes Mátyás Óvoda, Általános Iskola, Szakiskola és Készségfejlesztõ Iskola, Fejlesztõ Nevelés-Oktatást Végzõ Iskola,  Egységes Gyógypedagógiai Módszertani Intézmény" "Tatabányai TK")
    ("Tatabányai Erkel Ferenc Alapfokú Mûvészeti Iskola Botond Vezér utcai telephelye" "Tatabányai TK")
    ("Tatabányai Erkel Ferenc Alapfokú Mûvészeti Iskola Kodály Zoltán téri Telephelye" "Tatabányai TK")
    ("Tatabányai Erkel Ferenc Alapfokú Mûvészeti Iskola Sárberki lakótelepi telephelye" "Tatabányai TK")
    ("Tatabányai Erkel Ferenc Alapfokú Mûvészeti Iskola Tarjáni Telephelye" "Tatabányai TK")
    ("Tatabányai Kollégium" "Tatabányai TK")
    ("Új Út EGYMI Telephely" "Tatabányai TK")
    ("Új Út Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Kollégium, Fejlesztõ Nevelés-Oktatást Végzõ Iskola, Egységes Gyógypedagógiai Módszertani Intézmény Hegyháti Alajos Tagintézménye" "Tatabányai TK")
    ("Vaszary János Általános Iskola" "Tatabányai TK")
    ("Vértessomlói Német Nemzetiségi Általános Iskola" "Tatabányai TK")
    ("Vértesszõlõsi Általános Iskola" "Tatabányai TK")
    ("Acsai Petõfi Sándor Általános Iskola Csõvári Telephelye" "Váci TK")
    ("Cházár András Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Kollégium, Fejlesztõ Nevelést-Oktatást Végzõ Iskola Bárczi Gusztáv Tagintézmény telephelye" "Váci TK")
    ("Cházár András Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Kollégium, Fejlesztõ Nevelést-Oktatást Végzõ Iskola Bárczi Gusztáv Tagintézményének Tahitótfalui Telephelye" "Váci TK")
    ("Cházár András Egységes Gyógypedagógiai Módszertani Intézmény, Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Kollégium, Fejlesztõ Nevelést-Oktatást Végzõ Iskola Simon Antal Tagintézménye" "Váci TK")
    ("Dunabogdányi Általános Iskola és Alapfokú Mûvészeti Iskola" "Váci TK")
    ("Galgagyörki Gárdonyi Géza Általános Iskola" "Váci TK")
    ("Izbégi Általános Iskola Anna Utcai Telephelye" "Váci TK")
    ("Kalász Alapfokú Mûvészeti Iskola" "Váci TK")
    ("Kalász Alapfokú Mûvészeti Iskola - Klisovác utcai telephely" "Váci TK")
    ("Kalász Suli Általános Iskola" "Váci TK")
    ("Kvassay Jenõ Általános Iskola" "Váci TK")
    ("Nagymarosi Kittenberger Kálmán Általános Iskola és Alapfokú Mûvészeti Iskola" "Váci TK")
    ("Nagymarosi Kittenberger Kálmán Általános Iskola és Alapfokú Mûvészeti Iskola Váci úti Telephelye" "Váci TK")
    ("Pilisszentkereszti Szlovák Nemzetiségi Általános Iskola" "Váci TK")
    ("Pomázi Német Nemzetiségi Általános Iskola" "Váci TK")
    ("Rádi II. Rákóczi Ferenc Általános Iskola" "Váci TK")
    ("Szentendrei Barcsay Jenõ Általános Iskola" "Váci TK")
    ("Szentendrei II. Rákóczi Ferenc Általános Iskola és Gimnázium" "Váci TK")
    ("Szentistvántelepi Általános Iskola" "Váci TK")
    ("Szobi Fekete István Általános Iskola" "Váci TK")
    ("Szobi Fekete István Általános Iskola Esterházy-Huszár Általános Tagiskolája" "Váci TK")
    ("Szobi Fekete István Általános Iskola Kóspallag Telephelye" "Váci TK")
    ("Szobi Fekete István Általános Iskola Szokolyi Alajos Általános Tagiskolája" "Váci TK")
    ("Szobi Kodály Zoltán Alapfokú Mûvészeti Iskola Bernecebaráti Telephely" "Váci TK")
    ("Szobi Kodály Zoltán Alapfokú Mûvészeti Iskola Letkési Telephely" "Váci TK")
    ("Szobi Kodály Zoltán Alapfokú Mûvészeti Iskola Vámosmikolai Telephely" "Váci TK")
    ("Szokolyai Cseh Péter Általános Iskola" "Váci TK")
    ("Szõdligeti Gárdonyi Géza Általános Iskola" "Váci TK")
    ("Tahitótfalui Pollack Mihály Általános Iskola és Alapfokú Mûvészeti Iskola" "Váci TK")
    ("Tahitótfalui Pollack Mihály Általános Iskola és Alapfokú Mûvészeti Iskola Béke utcai Telephelye" "Váci TK")
    ("Teleki-Wattay Mûvészeti Iskola AMI Csobánkai telephely" "Váci TK")
    ("Teleki-Wattay Mûvészeti Iskola AMI Pomázi telephely" "Váci TK")
    ("Templomdombi Általános Iskola" "Váci TK")
    ("Vácdukai Benedek Elek Általános Iskola Telephelye" "Váci TK")
    ("Váchartyáni Apáczai Csere János Általános Iskola Kisnémedi Telephely" "Váci TK")
    ("Váci Árpád Fejedelem Általános Iskola" "Váci TK")
    ("Váci Bartók-Pikéthy Zenemûvészeti Szakgimnázium és Zeneiskola, Alapfokú Mûvészeti Iskola Acsai Telephelye" "Váci TK")
    ("Váci Bartók-Pikéthy Zenemûvészeti Szakgimnázium és Zeneiskola, Alapfokú Mûvészeti Iskola Deákvári fõtéri Telephelye" "Váci TK")
    ("Váci Bartók-Pikéthy Zenemûvészeti Szakgimnázium és Zeneiskola, Alapfokú Mûvészeti Iskola Németh L. utcai Telephelye" "Váci TK")
    ("Váci Bartók-Pikéthy Zenemûvészeti Szakgimnázium és Zeneiskola, Alapfokú Mûvészeti Iskola Penci Telephelye" "Váci TK")
    ("Váci Bartók-Pikéthy Zenemûvészeti Szakgimnázium és Zeneiskola, Alapfokú Mûvészeti Iskola Radnóti úti Telephelye" "Váci TK")
    ("Váci Bartók-Pikéthy Zenemûvészeti Szakgimnázium és Zeneiskola, Alapfokú Mûvészeti Iskola Vácdukai Telephelye" "Váci TK")
    ("Váci Bartók-Pikéthy Zenemûvészeti Szakgimnázium és Zeneiskola, Alapfokú Mûvészeti Iskola Vácrátóti Telephelye" "Váci TK")
    ("Váci Juhász Gyula Általános Iskola" "Váci TK")
    ("Váci Petõfi Sándor Általános Iskola" "Váci TK")
    ("Vácrátóti Petõfi Sándor Általános Iskola" "Váci TK")
    ("Vilcsek Gyula Általános Iskola Telephelye" "Váci TK")
    ("Visegrádi Áprily Lajos Általános Iskola Kisoroszi Tagintézménye" "Váci TK")
    ("Vujicsics Tihamér Alapfokú Mûvészeti Iskola Szentendre Duna korzó Telephelye" "Váci TK")
    ("Vujicsics Tihamér Alapfokú Mûvészeti Iskola Szentendre Mária utcai Telephelye" "Váci TK")
    ("Vujicsics Tihamér Alapfokú Mûvészeti Iskola Szentendre, Rákóczi Ferenc utcai Telephelye" "Váci TK")
    ("Zöldsziget Körzeti Általános Iskola Pócsmegyeri Telephelye" "Váci TK")
    ("Ady Endre Német Nemzetiségi Nyelvoktató Általános Iskola és Alapfokú Mûvészeti Iskola" "Veszprémi TK")
    ("Ányos Pál Német Nemzetiségi Nyelvoktató Általános Iskola" "Veszprémi TK")
    ("Balatonkenesei Pilinszky János Általános Iskola és Alapfokú Mûvészeti Iskola" "Veszprémi TK")
    ("Bán Aladár Általános Iskola Rákóczi Telepi Tagiskolája" "Veszprémi TK")
    ("Bartos Sándor Óvoda, Általános Iskola és Egységes Gyógypedagógiai Módszertani Intézmény" "Veszprémi TK")
    ("Berhidai II. Rákóczi Ferenc Német Nemzetiségi Nyelvoktató Általános Iskola" "Veszprémi TK")
    ("Borzavár-Porvai Német Nemzetiségi Nyelvoktató Általános Iskola Porvai Telephelye" "Veszprémi TK")
    ("Csermák Antal Alapfokú Mûvészeti Iskola Aradi Vértanúk Úti Telephelye" "Veszprémi TK")
    ("Csermák Antal Alapfokú Mûvészeti Iskola Brusznyai utcai telephelye" "Veszprémi TK")
    ("Csermák Antal Alapfokú Mûvészeti Iskola Herendi Telephelye" "Veszprémi TK")
    ("Csermák Antal Alapfokú Mûvészeti Iskola Nagyvázsonyi Telephelye" "Veszprémi TK")
    ("Csermák Antal Alapfokú Mûvészeti Iskola Szent István Utcai Telephelye" "Veszprémi TK")
    ("Csetényi Vámbéry Ármin Általános Iskola" "Veszprémi TK")
    ("Dudari Általános Iskola" "Veszprémi TK")
    ("Gyulaffy László Német Nemzetiségi Nyelvoktató Általános Iskola" "Veszprémi TK")
    ("Hajmáskéri Gábor Áron Általános Iskola Telephelye (tornaterem" 	"Veszprémi TK")
    ("Horváth István Általános Iskola" "Veszprémi TK")
    ("Hriszto Botev Német Nemzetiségi Nyelvoktató Általános Iskola" "Veszprémi TK")
    ("III. Béla Gimnázium, Mûvészeti Szakgimnázium és Alapfokú Mûvészeti Iskola" "Veszprémi TK")
    ("III. Béla Gimnázium, Mûvészeti Szakgimnázium és Alapfokú Mûvészeti Iskola Csetényi Telephelye" "Veszprémi TK")
    ("Kósa György Zenei Alapfokú Mûvészeti Iskola" "Veszprémi TK")
    ("Lovassy László Gimnázium" "Veszprémi TK")
    ("Nagyvázsonyi Kinizsi Pál Német Nemzetiségi Nyelvoktató Általános Iskola" "Veszprémi TK")
    ("Noszlopy Gáspár Gimnázium és Kollégium" "Veszprémi TK")
    ("Simonyi Zsigmond Ének-Zenei és Testnevelési Általános Iskola" "Veszprémi TK")
    ("Szentgáli Lõrincze Lajos Általános Iskola" "Veszprémi TK")
    ("Thuri György Gimnázium és Alapfokú Mûvészeti Iskola" "Veszprémi TK")
    ("Thuri György Gimnázium és Alapfokú Mûvészeti Iskola Hajmáskéri Telephelye" "Veszprémi TK")
    ("Thuri György Gimnázium és Alapfokú Mûvészeti Iskola Körmöcbánya utcai Telephelye" "Veszprémi TK")
    ("Thuri György Gimnázium és Alapfokú Mûvészeti Iskola Ösküi Telephelye" "Veszprémi TK")
    ("Thuri György Gimnázium és Alapfokú Mûvészeti Iskola Szent Imre utcai Telephelye" "Veszprémi TK")
    ("Thuri György Gimnázium és Alapfokú Mûvészeti Iskola Tési úti Telephelye" "Veszprémi TK")
    ("Várkerti Általános Iskola" "Veszprémi TK")
    ("Várkerti Általános Iskola Vásárhelyi András Tagiskolája" "Veszprémi TK")
    ("Veszprém Vármegyei Pedagógiai Szakszolgálat Ajkai Tagintézménye" "Veszprémi TK")
    ("Veszprém Vármegyei Pedagógiai Szakszolgálat Balatonfüredi Tagintézménye" "Veszprémi TK")
    ("Veszprém Vármegyei Pedagógiai Szakszolgálat Pápai Tagintézménye" "Veszprémi TK")
    ("Veszprém Vármegyei Pedagógiai Szakszolgálat Tapolcai Tagintézménye" "Veszprémi TK")
    ("Veszprém Vármegyei Pedagógiai Szakszolgálat Veszprémi Tagintézménye" "Veszprémi TK")
    ("Veszprémi Báthory István Sportiskolai Általános Iskola" "Veszprémi TK")
    ("Veszprémi Deák Ferenc Általános Iskola" "Veszprémi TK")
    ("Veszprémi Kossuth Lajos Általános Iskola" "Veszprémi TK")
    ("Veszprémi Rózsa Úti Általános Iskola" "Veszprémi TK")
    ("Vörösberényi Általános Iskola" "Veszprémi TK")
    ("Zirci Reguly Antal Német Nemzetiségi Nyelvoktató Általános Iskola "F" épület Telephelye" "Veszprémi TK")
    ("Zirci Reguly Antal Német Nemzetiségi Nyelvoktató Általános Iskola Villax Ferdinánd Tagiskolája" "Veszprémi TK")
    ("Bagodi Fekete István Általános Iskola Salomvári Tagintézménye" "Zalaegerszegi TK")
    ("Buda Ernõ Körzeti Általános Iskola" "Zalaegerszegi TK")
    ("Csertán Sándor Általános Iskola Nemesapáti Tagiskolája" "Zalaegerszegi TK")
    ("Deák Ferenc Általános Iskola és Gimnázium Telephelye" "Zalaegerszegi TK")
    ("Egervári László Általános Iskola" "Zalaegerszegi TK")
    ("Fazekas József Általános Iskola" "Zalaegerszegi TK")
    ("Göcsej Kapuja Bak Általános Iskola" "Zalaegerszegi TK")
    ("Kerkai Jenõ Általános Iskola" "Zalaegerszegi TK")
    ("Koncz Dezsõ Óvoda, Általános Iskola, Kollégium, Készségfejlesztõ Iskola és Egységes Gyógypedagógiai Módszertani Intézmény Batthyány utcai Telephelye" "Zalaegerszegi TK")
    ("Landorhegyi Sportiskolai Általános Iskola" "Zalaegerszegi TK")
    ("Lenti Ádám Jenõ Alapfokú Mûvészeti Iskola Csesztregi Telephelye" "Zalaegerszegi TK")
    ("Lenti Ádám Jenõ Alapfokú Mûvészeti Iskola Pákai Telephelye" "Zalaegerszegi TK")
    ("Lenti Ádám Jenõ Alapfokú Mûvészeti Iskola Zrínyi utcai Telephelye" "Zalaegerszegi TK")
    ("Lenti Általános Iskola és Gimnázium Arany János Tagintézménye" "Zalaegerszegi TK")
    ("Móricz Zsigmond Óvoda, Általános Iskola, Szakiskola, Készségfejlesztõ Iskola, Fejlesztõ Nevelés-Oktatást Végzõ Iskola, Kollégium és Egységes Gyógypedagógiai Módszertani Intézmény" "Zalaegerszegi TK")
    ("Pacsai Általános Iskola" "Zalaegerszegi TK")
    ("Pókaszepetki Festetics Kristóf Általános Iskola" "Zalaegerszegi TK")
    ("Szeliánszky Márta Általános Iskola, Készségfejlesztõ Iskola, Szakiskola és Egységes Gyógypedagógiai Módszertani Intézmény" "Zalaegerszegi TK")
    ("Teskándi Csukás István Általános Iskola" "Zalaegerszegi TK")
    ("Tófeji Kincskeresõ Általános Iskola Gutorföldi Telephelye" "Zalaegerszegi TK")
    ("Zala Vármegyei Pedagógiai Szakszolgálat" "Zalaegerszegi TK")
    ("Zala Vármegyei Pedagógiai Szakszolgálat Keszthelyi Tagintézményének Hévízi Telephelye" "Zalaegerszegi TK")
    ("Zala Vármegyei Pedagógiai Szakszolgálat Letenyei Tagintézménye" "Zalaegerszegi TK")
    ("Zala Vármegyei Pedagógiai Szakszolgálat Zalaegerszegi Tagintézménye" "Zalaegerszegi TK")
    ("Zalabéri Általános Iskola" "Zalaegerszegi TK")
    ("Zalaegerszegi Ady Endre Általános Iskola, Gimnázium és Alapfokú Mûvészeti Iskola Telephelye" "Zalaegerszegi TK")
    ("Zalaegerszegi Eötvös József Általános Iskola" "Zalaegerszegi TK")
    ("Zalaegerszegi Liszt Ferenc Általános Iskola" "Zalaegerszegi TK")
    ("Zalaegerszegi Öveges József Általános Iskola" "Zalaegerszegi TK")
    ("Zalaegerszegi Pálóczi Horváth Ádám Alapfokú Mûvészeti Iskola  Zalaegerszeg, Iskola utca 1.  Telephely" "Zalaegerszegi TK")
    ("Zalaegerszegi Pálóczi Horváth Ádám Alapfokú Mûvészeti Iskola  Zalaegerszeg, Szivárvány tér 1-3. Telephely" "Zalaegerszegi TK")
    ("Zalaegerszegi Pálóczi Horváth Ádám Alapfokú Mûvészeti Iskola Egervári Telephely" "Zalaegerszegi TK")
    ("Zalaegerszegi Pálóczi Horváth Ádám Alapfokú Mûvészeti Iskola Zalaegerszeg, Varkaus tér 1. Telephely" "Zalaegerszegi TK")
    ("Zalaegerszegi Pálóczi Horváth Ádám Alapfokú Mûvészeti Iskola Zalaszentiváni Telephelye" "Zalaegerszegi TK")
    ("Zalaegerszegi Városi Középiskolai Kollégium" "Zalaegerszegi TK")
    ("Zalaegerszegi Városi Középiskolai Kollégium Kovács Károly Tagkollégiuma" "Zalaegerszegi TK")
    ("Zalalövõi Általános Iskola" "Zalaegerszegi TK")
    ("Zalaszentgróti Erkel Ferenc Alapfokú Mûvészeti Iskola Batthyány utcai Telephelye" "Zalaegerszegi TK")
    ("Zalaszentgróti Erkel Ferenc Alapfokú Mûvészeti Iskola Türjei Telephelye" "Zalaegerszegi TK")))


(defun random-one (list)
  (nth (random (length list)) list))


(defun male-name (&optional (double nil))
  (let ((result (append (list (random-one *raw-surnames*)
                              (random-one *male-forenames*))
                        (when (> (random 1.0) 0.8)
                          (list (random-one *male-forenames*))))))
    (if (string= (second result) (third result))
      (male-name)
      (if double
        (list result result)
        result))))


(defun mrs (husband full)
  (if full
    (append (butlast husband) (list (concatenate 'string (first (last husband)) "né")))
    (list (concatenate 'string (first husband) "né"))))


(defun female-name (&optional (strictly-maiden-p nil))
  (let* ((married (> (random 1.0) 0.4))
         (type    (random 5))
         (husband (male-name))
         (maiden  (append (list (random-one *raw-surnames*)
                                (random-one *female-forenames*))
                          (when (> (random 1.0) 0.8)
                            (list (random-one *female-forenames*)))))
         (used    (case type
                    (0 (append (list (first husband)) (rest maiden)))
                    (1 (mrs husband t))
                    (2 (append (list (concatenate 'string (first (mrs husband nil))
                                                  " " (first maiden)))
                               (rest maiden)))
                    (3 (append (list (format nil "~{~a~^ ~} ~a"
                                             (mrs husband t)
                                             (first maiden)))
                               (rest maiden)))
                    (4 (append (list (concatenate 'string (first husband) "-" (first maiden)))
                               (rest maiden))))))
    (if (or (string= (second husband) (third husband))
            (string= (second maiden) (third maiden))
            (string= (first husband) (first maiden)))
      (female-name strictly-maiden-p)
      (if strictly-maiden-p
        maiden
        (list maiden (if married used maiden))))))


(defun place ()
  (let* ((inland    (<= (random 1.0) 0.96))
         (random    (random 1.0))
         (selection (butlast (find-if #'(lambda (row)
                                          (>= (first (last row))
                                              random))
                                      (if inland *settlements* *foreign-settlements*)))))
    (if (= (length selection) 1)
      (list (first selection) (first selection) "Magyarország")
      selection)))


(defun person ()
  (let* ((gender   (if (> (random 1.0) 0.55) 'male 'female))
         (year-min 1960)
         (year-max 2004)
         (year     (+ 1960 (random (- year-max year-min))))
         (month    (1+ (random 12)))
         (day      (1+ (random (nth (1- month) '(31 28 31 30 31 30 31 31 30 31 30 31)))))
         (name     (case gender
                     ('male   (male-name t))
                     ('female (female-name))))
         (place    (place))
         (mother   (female-name t)))
    (list
     :name       (second name)
     :birthname  (first name)
     :mother     mother
     :country    (third place)
     :settlement (first place)
     :birthdate  (format nil "~d-~2,'0d-~2,'0d" year month day)
     )))


(defun institution ()
  (random-one *institutions*))


(defun rank ()
  (random-one '("Igazgató" "Igazgató-helyettes" "Tanszakvezetõ"
                "Tanszakvezetõ-helyettes" "Tanár" "Portás")))


(defun id ()
  (concatenate 'string
               (loop for i from 0 below 6 collecting
                     (code-char (+ 48 (random 10))))
               (loop for i from 0 below 2 collecting
                     (code-char (+ 65 (random 26))))))


(defun phone ()
  (format nil "+36 (~a) ~3,'0d ~4,'0d"
          (if (> (random 1.0) 0.666)
            30 70)
          (random 1000)
          (random 10000)))


(defun email (name)
  (let ((rewrites '(("á" "a") ("é" "e") ("í" "i") ("ó" "o") ("ö" "o")
                    ("õ" "o") ("ú" "u") ("ü" "u") ("û" "u")))
        (hosts    '("suli" "isi" "kozokt" "intezmeny")))
    (labels ((repl (string rewrites)
               (if rewrites
                 (let ((r (first rewrites)))
                   (repl (str:replace-all (first r) (second r) string)
                         (rest rewrites)))
                 string)))
      (format nil "~{~a~^.~}@~a.hu"
              (reverse (mapcar #'(lambda (string)
                                   (repl (astring-downcase string) rewrites))
                               name))
              (random-one hosts)))))


(defun cert ()
  (string-upcase
   (wax::random-alphanumeric-string 16)))


(defun random-date-between (year1 month1 day1 year2 month2 day2)
  (let* ((from   (encode-universal-time 0 0 0 day1 month1 year1))
         (until  (encode-universal-time 0 0 0 day2 month2 year2))
         (random (+ from (random (- until from)))))
    (reverse (subseq (multiple-value-list (decode-universal-time random)) 3 6))))


(defun datestring (date)
  (apply #'format nil "~a-~2,'0d-~2,'0d" date))


(defun row (start-year)
  (let* ((institution (institution))
         (person      (person))
         (from        (random-date-between start-year 6 1 (+ start-year 3) 6 1))
         (til         (append (list (+ (first from) 3)) (rest from)))
         (state       (random-one '("Érvényes" "Visszavont"))))
    (append (list
             :institution (first institution)
             :rank (rank))
            person
            (list
             :id (id)
             :phone (phone)
             :email (email (getf person :name))
             :district (second institution)
             :cert (cert)
             :valid-from (datestring from)
             :valid-til  (datestring til)
             :type (random-one '("kiadmányozó" "alibi"))
             :medium (random-one '("Hardveres (CD)" "Hardveres (USB kulcs)"))
             :state state
             :redacted-p (if (string= state "Visszavont") "Igen" "")
             :redact-date (if (string= state "Visszavont") (datestring til) "")))))


(defun ensure3 (list)
  (if (= (length list) 2)
    (append list (list ""))
    list))


(defun print-row (row)
  (let* ((values (loop for (k v) on row by #'cddr collecting v))
         (repaired (append (subseq values 0 2)
                           (ensure3 (nth 2 values))
                           (ensure3 (nth 3 values))
                           (ensure3 (nth 4 values))
                           (subseq values 5))))
  (format t "~{~a~^|~}~%" repaired)))
