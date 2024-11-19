# Moviles-Informe-2 - Frontend

## Descripción
Este proyecto corresponde al Informe 2 del desarrollo de un frontend para una aplicación móvil utilizando el framework **Flutter**. La aplicación está diseñada para interactuar con el backend desarrollado en PHP, permitiendo la gestión de usuarios, registro, inicio de sesión y autenticación con JWT. La interfaz de usuario fue creada para ser intuitiva, con un enfoque en la facilidad de uso y la eficiencia en la interacción.

## Tecnologías Utilizadas
- **Flutter**: Framework utilizado para el desarrollo de la aplicación móvil multiplataforma.
- **Dart**: Lenguaje de programación utilizado en el desarrollo de aplicaciones con Flutter.
- **JWT (JSON Web Token)**: Utilizado para la autenticación segura de los usuarios, gestionando el acceso a las rutas protegidas de la aplicación.
- **Flutter Secure Storage**: Utilizado para almacenar de manera segura el token JWT en el dispositivo móvil.
- **Provider**: Maneja el estado y las dependencias en la aplicación, facilitando la gestión de la autenticación y la información del usuario.

## Instrucciones de Instalación

1. **Clonar el repositorio**:
   ```bash
   https://github.com/Alex-Trejo/Moviles-Informe-2.git

2. **Instalar Flutter (si no lo tienes instalado)**:
- Descarga e instala Flutter según tu sistema operativo.
- Asegúrate de tener configurado el entorno de desarrollo con Android Studio o cualquier otro editor compatible.

3. **Instalar dependencias**: Una vez clonado el repositorio, instala las dependencias necesarias para el proyecto ejecutando:
     ```bash
        flutter pub get

4. **Ejecutar la aplicación**: Conecta un dispositivo o usa un emulador y ejecuta la aplicación con:

    ```bash
        flutter run

- O puedes hacerlo desde el navegador

5. **Pruebas y autenticación:**
- La aplicación realiza solicitudes a la API de backend, por lo que es importante tener el servidor PHP y MySQL corriendo.

- La funcionalidad de autenticación usa JWT, por lo que asegúrate de que el backend esté configurado correctamente para emitir tokens.

## Estructura de la Aplicación

- **Página de Login** (`PaginaLogin.dart`): Permite a los usuarios iniciar sesión proporcionando su correo y contraseña.
- **Página de Registro** (`PaginaRegistro.dart`): Permite a los usuarios registrarse creando una cuenta con su nombre, correo y contraseña.
- **Página Principal** (`PaginaEstudiantes.dart`): Muestra el perfil del usuario una vez que está autenticado, con la opción de cerrar sesión.

## Rutas de la Aplicación

- **/login**: Página de inicio de sesión donde el usuario ingresa sus credenciales.
- **/register**: Página de registro donde el usuario puede crear una nueva cuenta.
- **/home**: Página de perfil que muestra la información del usuario una vez autenticado.

## Integrantes

- Silvia Ivón Añasco Rivadeneira
- Sheylee Arielle Enriquez Hernandez
- Yorman Javier Oña Gamarra
- Alex Fernando Trejo Duque

