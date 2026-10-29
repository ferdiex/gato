# Gato: minimax en Python y en Prolog

Material del laboratorio de búsqueda adversaria del curso de Inteligencia Artificial.

**Jugar:** https://ferdiex.github.io/gato/

[![Abrir en Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/ferdiex/gato/blob/main/notebook/gato_memoria.ipynb)

## El juego

Juegas al gato contra un agente minimax. El mismo agente está escrito en Python y en Prolog, y tú eliges cuál decide sus jugadas; incluso puedes cambiarlo a mitad de la partida. La página también muestra el valor minimax de cada casilla libre, deja vaciar la memoria del agente para comparar tiempos y tiene una partida de Python contra Prolog, que siempre termina en empate.

La página no reimplementa el juego en JavaScript: ejecuta dentro del navegador los mismos archivos de la clase, `gato.py` con [Pyodide](https://pyodide.org) y `gato.pl` con [SWI-Prolog para WebAssembly](https://github.com/SWI-Prolog/npm-swipl-wasm). La primera visita descarga los motores (unos 12 MB para Python y 4 MB para Prolog); después el navegador los guarda.

## Contenido

```
gato/
├── index.html              el juego (GitHub Pages lo publica tal cual)
├── gato.py                 gato con minimax en Python
├── gato.pl                 gato con minimax en Prolog
├── notebook/
│   └── gato_memoria.ipynb  experimentos: cuánto ayuda la memoria
├── minimax/
│   ├── minimax_alphabeta.py   minimax y alfa-beta en el árbol de las láminas
│   └── minimax_alphabeta.pl
└── presentaciones/
    ├── 1_minimax_alfabeta_prolog.pdf
    ├── 2_minimax_alfabeta_python.pdf
    └── 3_gato_python_prolog.pdf
```

## Jugar en la terminal

```bash
python3 gato.py
```

```bash
swipl gato.pl
?- game.
```

En Prolog cada jugada termina con punto, por ejemplo `4.` Las casillas se numeran así:

```
0 1 2
3 4 5
6 7 8
```

## Abrir la página en tu computadora

El navegador no deja que una página abierta como archivo lea `gato.py` y `gato.pl`, así que hay que servirla con un servidor local:

```bash
python3 -m http.server
```

y abrir http://localhost:8000

## Algunos resultados

- Con juego perfecto el gato termina en empate: el agente nunca pierde, juegue con X (101 partidas posibles) o con O (681).
- Sin memoria, resolver el tablero vacío hace 549,946 llamadas a minimax; con memoria (`@lru_cache` en Python, `:- table` en Prolog) solo hay 5,478 tableros distintos que resolver.
- Las versiones en Python y en Prolog eligen la misma jugada en las 447 posiciones donde decide el agente.

Fernando Montes-Gonzalez, Universidad Veracruzana
