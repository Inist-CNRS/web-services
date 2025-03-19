# ws-text-clustering@1.4.2

Crée différents *clusters* à partir d'un ensemble de textes courts ou d'un ensemble de listes de mots-clés. Ce web service est asynchrone et traite des corpus et non des documents.

Crée plusieurs groupes afin d'y classifier les différents textes en fonction de leur similarité.

> - Le nombre de *clusters* est déterminé de manière automatique et des documents peuvent être considérés comme du bruit (dans ce cas précis, le *label* de leur *cluster* sera `0` ; les documents appartenant au *cluster* 0 ne sont pas regroupés).
> - L'entrée peut être un texte court (type titre ou petit *abstract*), mais aussi une liste de mots-clés.
