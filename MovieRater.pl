:- consult("Dictionary").
:- consult("Corpus").
:- consult("Category").

%averaging the list. from-> http://stackoverflow.com/questions/12756072/prolog-avg-of-list
average( List, Average ):- 	sumlist( List, Sum ), 		% sum of all elements of the list
							length( List, Length ), 	% ind how many elements on the list
							Length > 0, 				% if list is not empty
							Average is Sum / Length. 	% get average from dividing sum to number of the elements in the list

%if the  word exists in a comment, get multiplication of comment rate with importance of the word as point of the word
rateFromComment(Word,Point) :- 	comment(Comment,Rate),		% if there is a comment
								member(Word,Comment), 		% that contains given word
								cate(Word,Importance), 		% find that word's importance from Category file
								Point is Importance * Rate. % then find the word's point by multiplying importance with comment rate

%get a list of the word's point from rateFromComment predicate for every comment that includes the word
ratelist(Word,ListPoint) :-	findall(Point,rateFromComment(Word,Point),ListPoint).

%ourate([given comment],[list of words' points list], [list of words' average points])
ourate([],[],[]).

%get all words' point list from the comment given, and find average of the list.
ourate([Head|Tail],ListofList,AverageList):-	ourate(Tail,ListofList1,AverageList1), 	%for every word in the given comment
												ratelist(Head,RateList), 				% find points from corpus file
												ListofList=[RateList|ListofList1], 		% append other points lists
												average(RateList,Average), 				% get average of points of that word
												AverageList=[Average|AverageList1]. 	% append it to other words' average point list

%same procedure above, but empty lists ignored
ourate([Head|Tail],ListofList,AverageList):-	ourate(Tail,ListofList1,AverageList1),
												ratelist(Head,RateList), 
												ListofList=[RateList|ListofList1],
												\+average(RateList,_), 					% if list does not have an element, 
												AverageList=AverageList1.				% do not add anything to the average list. 

%extractCate([given comment],[corresponding importance from Category file])
extractCate([],[]).

%extracting correspondence importance list from words of given comment, that is going to be needed for average calculation
extractCate([Head|Tail],ImportanceList) :-	extractCate(Tail,ImportanceList1), 				% for every word in the comment
											cate(Head,Importance), 							% find importance of that word
											ImportanceList = [Importance|ImportanceList1]. 	% add it to list of importance of words

%same as above, but do not add anything to the list if the word	does not exist in the dictionary								
extractCate([Head|Tail],ImportanceList) :- 	extractCate(Tail,ImportanceList1), 
											\+cate(Head,_),									% if word not exist in the dictionary
											ImportanceList = ImportanceList1.				% do not add something to the list

%the main predicate of the program, it predicts a final rate from given comment
finalaverage(TheComment,FinalPoint):-	ourate(TheComment,_,AverageList), 			% get average list of all words' point list from comment given
										extractCate(TheComment,ImportanceList),	 	% get importance list of given comment
										average(AverageList,A1), 					% takes average of the average list
										average(ImportanceList,AverageImportance), 	% takes average of the importance list
										FinalPoint is A1 / AverageImportance. 		% returns final point of the given comment
