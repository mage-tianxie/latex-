$pdf_mode = 5;
$go_mode = 1;

$pdflatex = "pdflatex -file-line-error -halt-on-error -interaction=nonstopmode -synctex=1 %O %S";
$xelatex = "xelatex -file-line-error -halt-on-error -interaction=nonstopmode -no-pdf -synctex=1 %O %S";
$xdvipdfmx = "xdvipdfmx -q -E -o %D %O %S";

$bibtex_use = 1.5;

$clean_ext = "hd synctex.gz xdv";

$makeindex = "makeindex -s gind.ist %O -o %D %S";
add_cus_dep('glo', 'gls', 0, 'glo2gls');
sub glo2gls {
    system("makeindex -s gglo.ist -o \"$_[0].gls\" \"$_[0].glo\"");
}
push @generated_exts, "glo", "gls";
