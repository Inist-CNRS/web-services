#!/usr/bin/perl


# Déclaration des pragmas
use strict;
use utf8;
use open qw/:std :utf8/;


# Appel des modules externes
use Encode qw(is_utf8);
# use Getopt::Long qw(:config bundling);
# use Getopt::Long qw(:config no_ignore_case bundling);
use Getopt::Long;
use POSIX qw(mkfifo);
use JSON;

# Recherche du nom du programme
my ($programme) = $0 =~ m|^(?:.*/)?(.+)|;
my $usage = "Usage : \n" .
            "    $programme -t table -r répertoire [ -e extension ]* [ -s fichier_sortie ] [ -l log ] [ -cq ]\n" .
            "    $programme -t table -f (fichier_entrée|-) [ -s fichier_sortie ] [ -l log ] [ -cq ]\n" .
            "    $programme -t table -j [ -f fichier_entrée ] [ -s fichier_sortie ] [ -l log ] [ -cq ]\n" .
            "    $programme -t table -p FIFO [ -l log ] [ -cw ]\n" .
            "    $programme -h\n\n";

my $version     = "4.5.1";
my $dateModif   = "31 Août 2022";

my @table = ();
my %genre = ();
my %liste = ();
my %pref  = ();
my %str   = ();

# Initialisation des variables globales
# nécessaires à la lecture des options
my $aide       = undef;
my $casse      = undef;
my $fichier    = undef;
my $json       = undef;
my $log        = undef;
my $fifo       = undef;
my $quiet      = undef;
my $repertoire = undef;
my $sortie     = undef;
my $table      = undef;
my $ws         = undef;
my @extensions = ();
my $recherche  = 0;
# Getopt::Long::Configure("no_ignore_case");
# Getopt::Long::Configure("bundling");

eval        {
        $SIG{__WARN__} = sub {usage(1);};
        GetOptions(
                "casse"        => \$casse,
                "extension=s"  => \@extensions,
                "fichier=s"    => \$fichier,
                "json"         => \$json,
                "help"         => \$aide,
                "log=s"        => \$log,
                "pipe=s"       => \$fifo,
                "quiet"        => \$quiet,
                "repertoire=s" => \$repertoire,
                "sortie=s"     => \$sortie,
                "table=s"      => \$table,
                "webservice"   => \$ws,
                );
        };
$SIG{__WARN__} = sub {warn $_[0];};

if ( $aide ) {
        print "\nProgramme : \n    \"$programme\", version $version ($dateModif)\n";
        print "    Adaptation du script Perl “IRC3.pl” permettant la reconnaissance et l’extraction \n";
        print "    dans un corpus de textes de noms scientifiques d’espèces animales ou végétales \n";
        print "    appartenant à une liste finie. En plus des noms in-extenso, ce programme recherche \n";
        print "    aussi les formes abrégées, par exemple : “C. lupus” pour “Canis lupus”. \n";
        print "    N.B. : la liste et les textes doivent être en UTF-8. \n\n";
        print $usage;
        print "Options :\n";
        print "    -c  tient compte de la casse (majuscule/minuscule) des termes recherchés \n";
        print "    -e  indique l'extension (e.g. “.txt”) du ou des fichiers textes à traiter \n";
        print "        (possibilité d’avoir plusieurs extensions en répétant l'option) \n";
        print "    -f  indique le nom du fichier texte à traiter (pour lire les données sur \n";
        print "        l’entrée standard, utilisez un tiret “-” comme argument) \n";
        print "    -h  affiche cette aide \n";
        print "    -j  indique que les données en entrée, dans un fichier ou sur l’entrée standard, \n";
        print "        sont en JSON ainsi que le résultat en sortie \n";
        print "    -l  indique le nom du fichier récapitulatif où sera écrit pour chaque fichier \n";
        print "        traité le nombre de termes et d’occurrences trouvés\n";
        print "    -p  indique le nom du tube nommé (“named pipe”) ou FIFO utilisé pour transmettre \n";
        print "        les données \n";
        print "    -q  supprime l’affichage de la progression du travail \n";
        print "    -r  indique le répertoire contenant les fichiers textes à traiter \n";
        print "    -s  indique le nom du fichier où sera écrit le résultat du traitement \n";
        print "    -t  indique le nom du fichier contenant la ressource, c'est-à-dire la liste \n";
        print "        des termes à rechercher \n";
        print "    -w  indique que le programme est utilisé par un “webservice” qui modifie le fichier \n";
        print "        envoyé en ne gardant que les objets JSON \n\n";
        print "Ressource : \n";
        print "    Le fichier de ressource contient un terme par ligne. On peut indiquer pour \n";
        print "    un terme sa forme préférentielle en ajoutant après le terme une ou plusieurs \n";
        print "    tabulations et le préférentiel. \n";
        print "    Les lignes vides et celles commençant par le caractère “#” ne sont pas prises \n";
        print "    en compte. De plus, la ressource peut être un fichier compressé par “gzip” ou \n";
        print "    “bzip2”. \n\n";
        print "Résultat : \n";
        print "    Le fichier résultat contient une ligne par occurrence trouvée. Chaque ligne \n";
        print "    est formée de 5 champs séparés par une tabulation. On a respectivement le nom \n";
        print "    du fichier traité (“STDIN” dans le cas de l'entrée standard), le terme tel \n";
        print "    qu'il apparait dans le texte analysé, la forme abrégée du terme tel qu'il est \n";
        print "    dans la ressource si c’est une forme abrégée qui a été trouvée, le terme tel \n";
        print "    qu'il est dans la ressource et, dans le cas d'un synonyme, la forme préférentielle \n";
        print "    du terme. \n\n";
        exit 0;
        }

# Vérification de la présence des options obligatoires
usage(2) if not $table;
usage(2) if not $fichier and not $repertoire and not $json and not $fifo;

if ( $log ) {
        open(LOG, ">:utf8", "$log") or die "$!,";
        }
else    {
        open(LOG, "> /dev/null") or die "$!,";
        }

if ( ! -f $table ) {
        print STDERR "$programme : fichier \"$table\" absent\n";
        usage(5);
        }
elsif ( $table =~ /\.g?[zZ]\Z/ ) {
        open(TAB, "gzip -cd $table |") or die "$!, ";
        binmode TAB, ":utf8";
        }
elsif ( $table =~ /\.bz2\Z/ ) {
        open(TAB, "bzip2 -cd $table |") or die "$!, ";
        binmode TAB, ":utf8";
        }
else    {
        open(TAB, "<:utf8", $table) or die "$!, ";
        }

$SIG{'HUP'} = 'nettoie';
$SIG{'INT'} = 'nettoie';
$SIG{'TERM'} = 'nettoie';

if ( $fifo ) {
        $quiet = 2;
        mkfifo($fifo, 0666) or die "Impossible de créer FIFO\x{A0}: $!,";
        }

print STDERR "\r", " " x 75, "\r Chargement de la ressource ...  " if not $quiet;

while (<TAB>) {
        next if /^#/o or /^\s*$/o;
        chomp;
        s/\r//go;

        # Vérification de jeu de caractères (doit être UTF-8)
        if ( not is_utf8($_, Encode::FB_QUIET) ) {
                print STDERR "Erreur : la table de référence doit être en UTF-8\n";
                exit 6;
                }

        my $pref =  "";
        my $terme = "";
        if ( /\t+/o ) {
                ($terme, $pref) = split(/\t+/o);
                }
        else    {
                $terme = $_;
                }
        $terme =~ s/^\p{IsSpace}+//o;
        $terme =~ s/\p{IsSpace}+\z//o;
#         $terme =~ s/\p{IsSpace}\p{IsSpace}+/ /o;
        my $str = $terme;
        if ( $terme =~ m|^\p{IsSpace}*\Z| or $terme =~ m|^\p{IsWord}-?\Z| ) {
                print STDERR "Terme refusé : \"$terme\"\n";
                next;
                }
        $terme = join(" ", grep(/\P{IsSpace}/, split(/(\P{IsWord})/, $terme)));
        $terme =~ s/  +/ /g;
        if ( not $casse ) {
                $terme = lc($terme);
                }
        if ( not $str{$terme} ) {
                $str{$terme} = $str;
                my ($genre) = $str =~ /^(\P{IsWord}*\p{IsWord}.*?) .+/o ? $1 : $str;
                $genre{$genre} ++;
                my $tmp = join(" ", grep(/\P{IsSpace}/, split(/(\P{IsWord})/, $genre)));
                if ( $casse ) {
                        $str{$tmp} = $genre if not $str{$tmp};
                        }
                else    {
                        $tmp = lc($tmp);
                        $str{$tmp} = $genre;
                        }
                push(@{$liste{$tmp}}, $terme);
                }
        else    {
#                 print STDERR "Erreur : doublon \"$str{$terme}\" et \"$str\"\n";
                print LOG "doublon \"$str{$terme}\" et \"$str\"\n";
                next;
                }
        if ( $pref ) {
                $pref =~ s/^\p{IsSpace}+//o;
                $pref =~ s/\p{IsSpace}+\z//o;
#                 $pref =~ s/\p{IsSpace}\p{IsSpace}+/ /o;
                $str = $pref;
                if ( $pref =~ m|^\p{IsSpace}*\Z| or $pref =~ m|^\p{IsWord}-?\Z| ) {
                        print STDERR "Préférentiel refusé : \"$pref\"\n";
                        next;
                        }
                $pref = join(" ", grep(/\P{IsSpace}/, split(/(\P{IsWord})/, $pref)));
                $pref =~ s/  +/ /g;
                if ( not $casse ) {
                        $pref = lc($pref);
                        }
                if ( not $str{$pref} ) {
                        $str{$pref} = $str;
                        my ($genre) = $str =~ /^(\P{IsWord}*\p{IsWord}.*?) .+/o ? $1 : $str;
                        $genre{$genre} ++;
                        my $tmp = join(" ", grep(/\P{IsSpace}/, split(/(\P{IsWord})/, $genre)));
                        if ( $casse ) {
                                $str{$tmp} = $genre if not $str{$tmp};
                                }
                        else    {
                                $tmp = lc($tmp);
                                $str{$tmp} = $genre;
                                }
                        push(@{$liste{$tmp}}, $pref);
                        }
                $pref{$terme} = $str;
                }
        }
close TAB;

my $prefRef   = \%pref;
my $strRef    = \%str;
my $fleche    = "";
my @resultats = ();

foreach my $genre (sort keys %liste) {
        if ( $casse ) {
                push(@table, sort @{$liste{$genre}}, $genre);
                }
        else    {
                push(@table, sort @{$liste{$genre}}, lc($genre));
                }
        }
my $nb = $#table + 1;

if ( $nb == 0 ) {
        print STDERR "\r", " " x 75, "\r Aucun terme présent dans la liste\n";
        exit 3;
        }

if ( not $quiet ) {
        my $tmp = $nb;
        1 while $tmp =~ s/(\d)(\d\d\d)\b/$1.$2/o;
        print STDERR "\r", " " x 75, "\r $tmp termes présents dans la liste\n" ;
        }

if ( $fifo ) {
        # $quiet  = 0;
        $json   = undef;
        $sortie = undef;
        my $retour = undef;
        my @json   = ();

        while( 1 ) {
                open(INP, "<:raw", $fifo) or die "$!,";
                # binmode(INP, ":raw");
                while(<INP>) {
                        if ( /^%% JOB POUR FIFO (.+)$/o ) {
                                $sortie = $1;
                                open(OUT, ">:utf8", $sortie) or die "$!,";
                                }
                        elsif ( /^%% FIN JOB/o ) {
                                $sortie = undef;
                                if ( $ws ) {
                                        $json = '[' . join(",", @json) . ']';
                                        @json = passe1($json);
                                        foreach $json (@json) {
                                                print OUT "$json\n";
                                                }
                                        @json = ();
                                        }
                                else    {
                                        ($json, $retour) = passe1($json);
                                        print OUT $json;
                                        }
                                close OUT;
                                $json = undef;
                                }
                        elsif ( $sortie ) {
                                if ( $ws ) {
                                        push(@json, $_);
                                        }
                                else   {
                                        $json .= $_;
                                        }
                                }
                        elsif ( /^%% STOP IRC3/o ) {
                                unlink $fifo;
                                exit 0;
                                }
                        }
                close INP;
                }
        nettoie();
        exit 2;
        }

select(STDERR);
$| = 1;
select (STDOUT);

if ( $sortie ) {
        open(OUT, ">:utf8", $sortie) or die "$!,";
        select OUT;
        }

if ( $json ) {
        if ( $fichier ) {
                traite_json($fichier);
                }
        else    {
                traite_json('-');
                }
        }
elsif ( $fichier ) {
        traite($fichier);
        }
elsif ( $repertoire ) {
        opendir(DIR, $repertoire) or die "$!,";
        my @fichiers = ();
        if ( @extensions ) {
                my $extensions = "(" . join("|", map {s/^\.//o; $_;} @extensions) . ")";
                @fichiers = grep(/\.$extensions\z/, grep(!/^\./o, readdir(DIR)));
                }
        else    {
                @fichiers = grep(!/^\./o, readdir(DIR));
                }
        closedir(DIR);
        foreach $fichier (sort @fichiers) {
                traite("$repertoire/$fichier");
                }
        }

nettoie();


exit 0;


sub usage
{
print STDERR "\n$usage";

exit shift;
}

sub dich
{
my ($key, $tref, $nbi) = @_;
my ($binf) = -1;
my ($bsup) = $nbi;

while ( $bsup > $binf + 1 ) {
        my $bmid = int ( ( $bsup + $binf) / 2 );
        my $comp = $key cmp $tref->[$bmid];
        return $bmid if $comp == 0;
        if ( $comp > 0 ) {
                $binf = $bmid;
                }
        else    {
                $bsup = $bmid;
                }
        }
return (- $bsup - 1);
}

sub traite
{
my $input = shift;

my $nom   = "";
if ( $input eq '-' ) {
        open(INP, "<&STDIN") or die "Impossible de dupliquer STDIN: $!,";
        binmode(INP, ":utf8");
        $nom = "STDIN";
        }
else    {
        open(INP, "<:utf8", $input) or die "$!,";
        ($nom) = $input =~ m|^(?:.*/)?(.+)|o;
        }

my $texte     = "";
my @para      = ();
my %tmp       = ();

# On pense à vides la liste
@resultats = ();

# Première passe -> fléche simple
$fleche = '->';

print STDERR "\r", " " x 75, "\r Traite le fichier $nom  " if not $quiet;

while(<INP>) {
        # Vérification de jeu de caractères (doit être UTF-8)
        if ( not is_utf8($_, Encode::FB_QUIET) ) {
                if ( $nom eq 'STDIN' ) {
                        print STDERR "Erreur : le texte en entrée standard doit être en UTF-8\n";
                        }
                else    {
                        print STDERR "Erreur : le fichier \"$nom\" doit être en UTF-8\n";
                        }
                exit 7;
                }

        if ( /^\s*$/o ) {
                if ( $texte ) {
                        push(@para, $texte);
                        push(@resultats, recherche($nom, $texte));
                        $texte = "";
                        }
                next;
                }
        tr/\n\r/  /s;
        $texte .= $_;
        }

if ( $texte ) {
        push(@resultats, recherche($nom, $texte));
        $texte = "";
        }

close INP;

# Penser au cas où on ne trouve rien lors de la première passe
if ( not @resultats ) {
        print LOG "0\t0\t$nom\n";
        return;
        }

@resultats = passe2($nom, \@resultats, \@para);
}

sub traite_json
{
my $nom = shift;

if ( $nom eq '-' ) {
        open(INP, "<&STDIN") or die "Impossible de dupliquer STDIN: $!,";
        binmode(INP, ":raw");
        $nom = 'STDIN';
        }
else    {
        open(INP, "<:raw", $nom) or die "$!,";
        }

my $texte     = undef;
my @id        = ();
my @para      = ();
my %para      = ();
my %resultats = ();
my %tmp       = ();

# On pense à vides la liste
@resultats = ();

# Première passe -> fléche simple
$fleche = '->';

print STDERR "\r", " " x 75, "\r Traite le fichier $nom  " if not $quiet;

my $input = "";
my @input = ();
my %input = ();

while(<INP>) {
        $input .= $_;
        }
close INP;

my ($json, $retour) = passe1($input);

print $json;

if ( $retour ) {
        nettoie();
        exit $retour;
        }
}

sub passe1
{
my $input = shift;

# Variables
my $nom       = undef;
my $texte     = undef;
my @id        = ();
my @input     = ();
my @para      = ();
my %input     = ();
my %para      = ();
my %resultats = ();
my %tmp       = ();

my $perl = undef;
eval    {
        $perl = decode_json $input;
        };
if ( $@ ) {
        $@ =~ s/"/\\"/go;
        $@ =~ s/[\r\n]//go;
        $@ =~ s/at $0 .+//go;
        if ( $ws ) {
                return("{\"message\": \"erreur de conversion des données JSON vers Perl.\", \"explication\": \"$@\"}\n");
                }
        else    {
                return("[{\"message\": \"erreur de conversion des données JSON vers Perl.\", \"explication\": \"$@\"}]\n", 4);
                }
        }
if ( ref($perl) eq 'ARRAY' ) {
        @input = @{$perl};
        foreach my $doc (@input) {
                my %doc = %{$doc};
                $nom = $doc{'id'};
                push(@id, $nom);
                my $value = $doc{'value'};
                if ( ref($value) eq 'ARRAY' ) {
                        my @values = @{$value};
                        foreach my $item (@values) {
                                push(@para, $item);
                                push(@resultats, recherche($nom, $item));
                                }
                        }
                else    {
                        push(@para, $value);
                        push(@resultats, recherche($nom, $value));
                        }
                if ( @resultats ) {
                        @{$para{$nom}} = @para;
                        @para = ();
                        @{$resultats{$nom}} = @resultats;
                        @resultats = ();
                        }

                }
        }
elsif ( ref($perl) eq 'HASH' ) {
        %input = %{$perl};
        $nom = $input{'id'};
        push(@id, $nom);
        my $value = $input{'value'};
        if ( ref($value) eq 'ARRAY' ) {
                my @values = @{$value};
                foreach my $item (@values) {
                        push(@para, $item);
                        push(@resultats, recherche($nom, $item));
                        }
                }
        else    {
                push(@para, $value);
                push(@resultats, recherche($nom, $value));
                }
        if ( @resultats ) {
                @{$para{$nom}} = @para;
                @para = ();
                @{$resultats{$nom}} = @resultats;
                @resultats = ();
                }
        }

my @tmp = ();
foreach $nom (@id) {
        my @ambigus = ();
        my %especes = ();
        my $tmp = "  {\n    \"id\": \"$nom\",\n";
        if ( defined $resultats{$nom} ) {
                @resultats = passe2($nom, \@{$resultats{$nom}}, \@{$para{$nom}});
#               foreach my $item (@resultats) {
                while ( my $item = shift @resultats ) {
                        my @champs = split(/\t/, $item);
                                if ( $champs[2] =~ /^\?.+\?\z/o ) {
                                        push(@ambigus, $item);
                                        }
                                else    {
                                        $especes{$champs[2]} ++;
                                        }
                        }
                }
        my @especes = sort keys %especes;
        if ( @especes ) {
                $tmp .= $ws ? " \"value\": [\n" : "    \"species\": [\n";
                while (my $item = shift @especes) {
                        $tmp .= "      \"$item\"";
                        $tmp .= ", " if @especes;
                        $tmp .= "\n";
                        }
                $tmp .= "    ]\n";
                }
        else    {
                $tmp .= "    \"species\": []\n";
                }
        $tmp .= "  }";
        push(@tmp, $tmp);
        }
if ( $ws ) {
        foreach my $item (@tmp) {
                $item =~ s/^ *//o;
                $item =~ s/,\n */, /go;
                $item =~ s/\n *//go;
                }
        return @tmp;
        }
else    {
        return ("[\n" . join(",\n", @tmp) . "\n]\n", 0);
        }
}

sub passe2
{
my ($id, $ref_liste, $ref_para) = @_;
my @liste = @{$ref_liste};
my @para = @{$ref_para};

# Deuxième passe => fléche double
$fleche = '=>';

# Préparation de la table
my %tmp  = ();
my @tmp1 = sort grep {not $tmp{$_} ++;} @liste;
my @tmp2 = ();
%tmp = ();

foreach my $item (@tmp1) {
        my ($terme) = split(/\t/o, $item);
        my ($genre) = $terme =~ /^(\P{IsWord}*\p{IsWord}.*?) .+/o ? $1 : $terme;
        $genre = join(" ", grep(/\P{IsSpace}/, split(/(\P{IsWord})/, $genre)));
        $genre = lc($genre) if not $casse;
        push(@tmp2, $genre);
        if ( $liste{$genre} ) {
                push(@tmp2, @{$liste{$genre}});
                }
        else    {
                push(@tmp2, grep(/^$genre\p{IsSpace}/, @table));
                }
        }
@tmp1 = sort grep {not $tmp{$_} ++;} @tmp2;

my %tmpPref = ();
my %tmpStr  = ();

@tmp2 = ();
foreach my $terme (@tmp1) {
        if ( $casse ) {
                # my $str = join(" ", grep(/\P{IsSpace}/, split(/(\P{IsWord})/, $terme)));
                push(@tmp2, $terme);
                if ( $str{$terme} ) {
                        $tmpStr{$terme} = $str{$terme};
                        }
                else    {
                        print STDERR "Pas de forme canonique pour \"$terme\"\n";
                        next;
                        }
                if ( $terme =~ /^(\p{IsUpper})\P{IsSpace}+\p{IsSpace}+(.+)/o ) {
                        my $abrev = "$1. $2";
                        my $str = join(" ", grep(/\P{IsSpace}/, split(/(\P{IsWord})/, $abrev)));
                        push(@tmp2, $str);
                        $tmpStr{$str} = $abrev;
                        if ( $tmpPref{$str} ) {
                                $tmpPref{$str} .= " ; $str{$terme}";
                                }
                        else    {
                                $tmpPref{$str} = $str{$terme};
                                }
                        }
                }
        else    {
               #  my $str = join(" ", grep(/\P{IsSpace}/, split(/(\P{IsWord})/, lc($terme))));
                push(@tmp2, $terme);
                if ( $str{$terme} ) {
                        $tmpStr{$terme} = $str{$terme};
                        # $tmpStr{$str} = $str{$terme} if $str ne $terme;
                        }
                else    {
                        print STDERR "Pas de forme canonique pour \"$terme\"\n";
                        next;
                        }
                if ( $terme =~ /^(\p{IsLower})\P{IsSpace}+\p{IsSpace}+(.+)/o ) {
                        my $abrev = "$1. $2";
                        my $str = join(" ", grep(/\P{IsSpace}/, split(/(\P{IsWord})/, lc($abrev))));
                        push(@tmp2, $str);
                        $tmpStr{$str} = "\u$abrev";
                        if ( $tmpPref{$str} ) {
                                # $tmpPref{$str} .= " ; " . $str{$terme};
                                $tmpPref{$str} .= " ; " . $terme;
                                }
                        else    {
                                # $tmpPref{$str} = $str{$terme};
                                $tmpPref{$str} = $terme;
                                }
                        }
                }
        }
%tmp = ();
@tmp1 = sort grep{not $tmp{$_} ++;} @tmp2;

@liste = ();
%tmp = ();

# On point sur les nouveaux hachages ...
$prefRef = \%tmpPref;
$strRef  = \%tmpStr;

foreach my $para (@para) {
        push(@liste, recherche($id, $para, \@tmp1));
        }

# Traitement des ambigüités toujours présentes
@tmp1 = grep{not $tmp{$_} ++;} grep(/\t\?.+\?\z/, @liste);
if ( @tmp1 ) {
        @tmp2 = grep(!/\t\?.+\?\z/, @liste);
        foreach my $item (@tmp1) {
                my ($t1, $t2, $t3) = split(/\t/, $item);
                %tmp = ();
                my @tmp3 = grep{not $tmp{$_} ++;} grep(/./, split(/\?/, $t3));
                my %score = ();
                foreach my $pref (@tmp3) {
                        $score{$pref} = grep(/$t1\t[^\t]+\t$pref\z/, @tmp2);
                        }
                my @tmp = sort {$score{$b} <=> $score{$a}} grep {$score{$_} > 0;} keys %score;
                if ( $#tmp == 0 ) {
                        foreach my $resultat (@liste) {
                                if ( $resultat eq $item ) {
                                        $resultat = "$t1\t$t2\t$tmp[0]";
                                        }
                                }
                        }
                next if @tmp;
                %score = ();
                foreach my $pref (@tmp3) {
                        $score{$pref} = grep(/\t$pref\z/, @tmp2);
                        }
                @tmp = sort {$score{$b} <=> $score{$a}} grep {$score{$_} > 0;} keys %score;
                if ( $#tmp == 0 ) {
                        foreach my $resultat (@liste) {
                                if ( $resultat eq $item ) {
                                        $resultat = "$t1\t$t2\t$tmp[0]";
                                        }
                                }
                        next;
                        }
                %tmp = ();
                foreach my $pref (@tmp3) {
                        my ($genre) = $pref =~ /^(.+?) /o;
                        $tmp{$genre} ++;
                        }
                for ( my $n = 1 ; $n <= $#liste ; $n ++ ) {
                        if ( $liste[$n] eq $item ) {
                                for ( my $m = $n ; $m >= 0 ; $m -- ) {
                                        my ($terme) = $liste[$m] =~ /^(.+?)\s/o;
                                        next if not $genre{$terme};
                                        if ( $tmp{$terme} ) {
                                                @tmp = grep(/^$terme /, @tmp3);
                                                if ( $#tmp == 0 ) {
                                                        foreach my $resultat (@liste) {
                                                                if ( $resultat eq $item ) {
                                                                        $resultat = "$t1\t$t2\t$tmp[0]";
                                                                        }
                                                                }
                                                        }
                                                }
                                        }
                                }
                        }
                }
        }


# ... et retour aux hachages par défaut.
$prefRef = \%pref;
$strRef  = \%str;

@tmp1 = ();

while( my $resultat = shift @liste ) {
        my @champs = split(/\t/, $resultat);
        next if $genre{$champs[0]};
        if ( $champs[2] ) {
                $resultat = "$champs[1]\t$champs[0]\t$champs[2]\t$pref{$champs[2]}";
                }
        else    {
                $resultat = "$champs[1]\t\t$champs[0]\t$pref{$champs[0]}";
                }
        print STDERR "\r", " " x 75, "\r" if not $quiet;
        if ( $json ) {
                push(@tmp1, $resultat);
                }
        else    {
                print "$id\t$resultat\n";
                }
        if ( $champs[2] ) {
                if ( $champs[2] =~ /^\?.+\?\z/o and not $json ) {
                        print STDERR "ATTENTION ! $id : ambiguïté sur la forme non abrégée de “$champs[0]” !\n" if not $quiet;
                        print LOG "ATTENTION ! $id : ambiguïté sur la forme non abrégée de “$champs[0]” !\n";
                        }
                else    {
                        $tmp{$champs[2]} ++;
                        }
                }
        else    {
                $tmp{$champs[0]} ++;
                }
        }

my $nb_refs = 0;
my $nb_occs = 0;

foreach my $ref (keys %tmp) {
        $nb_refs ++;
        $nb_occs += $tmp{$ref};
        }

printf LOG "%d\t%d\t%s\n", $nb_refs, $nb_occs, $id;

return @tmp1 if $json;
}

sub recherche
{
my $cle  = undef;
my $orig = undef;
my $tref = undef;
my $nbi  = $nb;

($cle, $orig, $tref) = @_;

if ( not defined $tref ) {
        $tref = \@table;
        }
else    {
        $nbi = $#{$tref} + 1;
        }
$orig =~ s/^\p{IsSpace}+//o;
$orig =~ s/\p{IsSpace}+\z//o;
my $rec = join(" ", grep(/\P{IsSpace}/, split(/(\P{IsWord})/, $orig)));
if ( ! $casse ) {
        $rec = lc($rec);
        }

my $terme = "";
my @matchs = ();

while ( length($rec) ) {
        my $retour = dich($rec, $tref, $nbi);
        my $bout = join(" ", (grep(/\P{IsSpace}/, split(/( )/, $rec)))[0 .. 1] );
        my $biniou = 1;
        if ( $retour > -1 ) {
                print STDERR "\r", " " x 75, "\r" if not $quiet;
                $terme = $tref->[$retour];
                my $tmp = $tref->[$retour];
                $terme =~ s/(\P{IsWord})/\\$1/go;
                $terme =~ s/\\ /\\s*/og;
                $terme =~ s/([^\x20-\x7F])/./og;
                if ( $orig =~ /^$terme\b/ or ( ! $casse and $orig =~ /^$terme\b/i ) ) {
                        my $chaine = $&;
                        if ( $chaine =~ /\p{IsUpper}/o ) {
                                push(@matchs, "$strRef->{$tmp}\t$chaine");
                                if ( defined $prefRef->{$tmp} ) {
                                        if ( $prefRef->{$tmp} =~ / ; /o ) {
                                                my @possibles = split(/ ; /, $prefRef->{$tmp});
                                                my $probable = desambiguise(\@possibles, \@matchs);
                                                if ( $probable ) {
                                                        $matchs[$#matchs] .= "\t$strRef->{$probable}";
                                                        }
                                                else    {
                                                        $probable = join('?', map {$strRef->{$_}} @possibles);
                                                        $matchs[$#matchs] .= "\t?$probable?";
                                                        }
                                                }
                                        else    {
                                                $matchs[$#matchs] .= "\t$strRef->{$prefRef->{$tmp}}";
                                                }
                                        }
                                }
                        }
                else    {
                        push(@matchs, "$strRef->{$tmp}\t*** ERREUR ***");
                        print STDERR "ERREUR (1) sur la recherche de l'original $cle\n";
                        }
                if ( not $quiet and not $genre{$strRef->{$tmp}} ) {
#                if ( not $quiet ) {
                        print STDERR "$cle $fleche $strRef->{$tmp}\n";
                        print STDERR " Traite le fichier $cle  ";
                        }
                }
        else    {
                $retour = - 2 - $retour;
                $terme = $tref->[$retour];
                my ($debut) = $terme =~ m|^(.*?\p{IsWord}+)|;
                $debut =~ s/(\P{IsWord})/\\$1/g;
                if ( $debut and $rec =~ /^$debut\b/ ) {
                        do {
                                # print "$retour\t$debut\t$terme\t$bout\n";
                                $terme =~ s/(\P{IsWord})/\\$1/g;
                                if ( $rec =~ /^$terme\b/ ) { # Mot exact seulement
                                        print STDERR "\r", " " x 75, "\r" if not $quiet;
                                        $terme =~ s/\\ /\\p{IsSpace}*/og;
                                        my $alt = $terme;
                                        $alt =~ s/(\\?[^\x20-\x7F])/./og;
                                        my $tmp = $tref->[$retour];
                                        if ( $orig =~ /^$terme/ or ( not $casse and $orig =~ /^$terme/i ) ) {
                                                my $chaine = $&;
                                                if ( $chaine =~ /\p{IsUpper}/o ) {
                                                        push(@matchs, "$strRef->{$tmp}\t$chaine");
                                                        if ( defined $prefRef->{$tmp} ) {
                                                                if ( $prefRef->{$tmp} =~ / ; /o ) {
                                                                        my @possibles = split(/ ; /, $prefRef->{$tmp});
                                                                        my $probable = desambiguise(\@possibles, \@matchs);
                                                                        if ( $probable ) {
                                                                                $matchs[$#matchs] .= "\t$strRef->{$probable}";
                                                                                }
                                                                        else    {
                                                                                $probable = join('?', map {$strRef->{$_}} @possibles);
                                                                                $matchs[$#matchs] .= "\t?$probable?";
                                                                                }
                                                                        }
                                                                else    {
                                                                        $matchs[$#matchs] .= "\t$strRef->{$prefRef->{$tmp}}";
                                                                        }
                                                                }
                                                        }
                                                }
                                        elsif ( $orig =~ /^$alt/ or ( not $casse and $orig =~ /^$alt/i ) ) {
                                                my $chaine = $&;
                                                if ( $chaine =~ /\p{IsUpper}/o ) {
                                                        push(@matchs, "$strRef->{$tmp}\t$chaine");
                                                        if ( defined $prefRef->{$tmp} ) {
                                                                if ( $prefRef->{$tmp} =~ / ; /o ) {
                                                                        my @possibles = split(/ ; /, $prefRef->{$tmp});
                                                                        my $probable = desambiguise(\@possibles, \@matchs);
                                                                        if ( $probable ) {
                                                                                $matchs[$#matchs] .= "\t$strRef->{$probable}";
                                                                                }
                                                                        else    {
                                                                                $probable = join('?', map {$strRef->{$_}} @possibles);
                                                                                $matchs[$#matchs] .= "\t?$probable?";
                                                                                }
                                                                        }
                                                                else    {
                                                                        $matchs[$#matchs] .= "\t$strRef->{$prefRef->{$tmp}}";
                                                                        }
                                                                }
                                                        }
                                                }
                                        else    {
                                                push(@matchs, "$strRef->{$tmp}\t*** ERREUR ***");
                                                print STDERR "ERREUR (2) sur la recherche de l'original $cle\n";
                                                }
                                        if ( not $quiet and not $genre{$strRef->{$tmp}} ) {
                                                print STDERR "$cle $fleche $strRef->{$tmp}\n";
                                                print STDERR " Traite le fichier $cle  ";
                                                }
                                        $retour = 0;
                                        }
                                if ( $retour > 0 ) {
                                        $terme = $tref->[--$retour];
                                        }
                                else    {
                                        $terme = "";
                                        }
                                } until $terme !~ /^$debut/;
                        }
                }
        $rec =~ s/^\P{IsSpace}+\p{IsSpace}?//;
        if ( $orig =~ /^\p{IsWord}+\p{IsSpace}*/ ) {
                $orig =~ s/^\p{IsWord}+\p{IsSpace}*//;
                }
        elsif ( $orig =~ /^\p{IsSpace}+\P{IsWord}\p{IsSpace}*/ ) {
                $orig =~ s/^\p{IsSpace}+\P{IsWord}\p{IsSpace}*//;
                }
        elsif ( $orig =~ /^\P{IsWord}\p{IsSpace}*/ ) {
                $orig =~ s/^\P{IsWord}\p{IsSpace}*//;
                }
        else    {
                print STDERR "ERREUR sur le texte intégral : $orig\n";
                }
        }

return @matchs;
}

sub desambiguise
{
my $ptrPossibles = shift;
my $ptrMatchs    = shift;
return undef;
my @references = ();

foreach my $resultat (@resultats) {
        my @tmp = split(/\t/, $resultat);
        if ( $tmp[2] ) {
                next if $tmp[2] =~ /^\?.+\?\z/o;
                push(@references, $tmp[2]);
                }
        elsif ( $tmp[0] !~ /^\w\. /o ) {
                push(@references, $tmp[0]);
                }
        }

foreach my $resultat (@{$ptrMatchs}) {
        my @tmp = split(/\t/, $resultat);
        if ( $tmp[2] ) {
                next if $tmp[2] =~ /^\?.+\?\z/o;
                push(@references, $tmp[2]);
                }
        elsif ( $tmp[0] !~ /^\w\. /o ) {
                push(@references, $tmp[0]);
                }
        }

my %score = ();
my %tmp   = ();

my @liste = grep {not $tmp{$_} ++;} reverse @references;

foreach my $possible (@{$ptrPossibles}) {
        foreach my $item (@liste) {
                if ( $item eq $str{$possible} ) {
                        $score{$possible} = 1 ;
                        }
                }
        }

my @tmp = sort keys %score;
if ( $#tmp == 0 ) {
        return $tmp[0];
        }

foreach my $item (@liste) {
        my ($genre) = $item =~ /^(\S+) /o;
        next if not $genre;
        if ( not $casse ) {
                $genre = lc($genre);
                }
        my ($possible) = grep(/^$genre /, @{$ptrPossibles});
        return $possible if $possible;
        }
}

sub nettoie
{
if ( $fifo and -p $fifo ) {
        unlink $fifo;
        }
if ( not $quiet ) {
        print STDERR "\r", " " x 75, "\r";
        print STDERR "\n";
        }

exit 0;
}
