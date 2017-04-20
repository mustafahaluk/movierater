%----------catefile.------------------------------
%importance of the words
cate(X,0.3) :- isim(X),!.
cate(X,0.1) :- baglac(X),!.
cate(X,0.1) :- edat(X),!.
cate(X,0.1) :- ekfiil(X),!.
cate(X,0.3) :- fiil(X),!.
cate(X,0.9) :- sifat(X),!.
cate(X,0.1) :- zamir(X),!.
cate(X,0.9) :- zarf(X),!.

%-------------------------------------
