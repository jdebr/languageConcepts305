% Joseph DeBruycker
% CSCI 305 Lab 4
% Spring 2015


% Parents
% A mother is a parent who is female.
% A father is a parent who is male.
mother(M,C) :- parent(M,C), female(M).
father(F,C) :- parent(F,C), male(F).


% Spouse
% A husband and wife are spouses if the husband married the wife.
spouse(H,W) :- married(H,W).
spouse(W,H) :- married(H,W).


% Child
% A child is someone with a parent.
child(C,P) :- parent(P,C).


% Son
% A son is a child who is male.
son(S,P) :- child(S,P), male(S).


% Daughter
% A daughter is a child who is female.
daughter(D,P) :- child(D,P), female(D).


% Sibling
% Two people are siblings if they are both children of the same parents.
% A person cannot be their own sibling.
sibling(X,Y) :- child(X,Z), child(Y,Z), X \= Y.


% Brother
% A brother is a sibling who is male.
brother(B,X) :- sibling(B,X), male(B).


% Sister
% A sister is a sibling who is female.
sister(S,Y) :- sibling(S,Y), female(S).


% Uncle
% An uncle is a brother of a parent (blood).
% An uncle is a spouse of a sister of a parent (marriage).
uncle(U,N) :- parent(X,N), brother(U,X).
uncle(U,N) :- parent(X,N), sister(Y,X), spouse(U,Y).


% Aunt
% An aunt is a sister of a parent (blood).
% An aunt is a spouse of a brother of a parent (marriage).
aunt(A,N) :- parent(X,N), sister(A,X).
aunt(A,N) :- parent(X,N), brother(Y,X), spouse(A,Y).


% Grandparent
% A grandparent is the parent of a parent.
grandparent(G,C) :- parent(G,X), parent(X,C).


% Grandfather
% A grandfather is a grandparent who is male.
grandfather(G,C) :- grandparent(G,C), male(G).


% Grandmother
% A grandmother is a grandparent who is female.
grandmother(G,C) :- grandparent(G,C), female(G).


% Grandchild
% A grandchild is someone with a grandparent.
grandchild(C,G) :- grandparent(G,C).


%%%%%%%%%%%
% Ancestors 
%%%%%%%%%%%

% A person is an ancestor of another person if they are a parent, grandparent,
% great-grandparent, etc. of that person.
ancestor(A,D) :- parent(A,D).
ancestor(A,D) :- parent(A,X), ancestor(X,D).


% A person is a descendant of another person if that person is their ancestor!
descendant(D,A) :- ancestor(A,D).


%%%%%%%%
% Ages
%%%%%%%%

% A person is older than someone if they were born before them, that is the
% year they were born is a smaller number numerically
older(O,Y) :- born(O, A), born(Y, B), A < B.

% Conversely, a person is younger if they were born after, or the year they
% were born is a larger number 
younger(Y,O) :- born(Y, A), born(O, B), A > B.


% Regent When Born
% This rule determines who was reigning as King or Queen when a person was born
regentWhenBorn(X,Y) :- reigned(X, A, B), born(Y, C), A =< C, C =< B.