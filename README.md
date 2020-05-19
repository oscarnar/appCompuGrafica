# App de Computacion Grafica

Esta app desarrollada con Flutter tiene como finalidad mostrar los algoritmos basicos de
computación gráfica con una interfaz intuitiva.

## Compilar

Antes de compilar debemos tener instalado [Flutter](https://flutter-es.io/) la version mas reciente.

## Obtener algunos packetes que usamos

Debemos hacer un `packages get` para actualizar los paquetes. Pero antes debemos comentar algunas lineas en `nuestro pubspec.yaml`.

Comentamos la siguientes lineas
```bash
\#flutter_test:
\#  sdk: flutter
```

Ahora hacemos un `packages get`, ejecutamos lo siguiente dentro del proyecto:
```bash
flutter packages get
```
Descomentamos lo anterior y volvemos hacer un `packages get` y listo.

## Compilar

Para compilar solo debemos tener un dispositivo android disponible (No esta habilitado para web)
y correr la aplicación:
```bash
flutter run
```
