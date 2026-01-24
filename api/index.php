<?php

/* 
como Angular corre en el puerto 4200 con su servidor interno y XAMPP corre en el 80 
el navegador bloqueará la conexión por seguridad.
para su correcta vinculacion se requiere usar...
*/
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Authorization, Content-Type");
header("Access-Control-Allow-Methods: GET, POST, PATCH, DELETE, OPTIONS");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    die;
}

// Para obtener la variable $link de la conexion a la BD
require_once "../config/config.php";

// Si no se envió "acción" de protocolo HTTP
if (!isset($_GET['accion'])) {
    outputError(400);
}

$metodo = strtolower($_SERVER['REQUEST_METHOD']); // obtiene el metodo llamado
$accion = explode('/', strtolower($_GET['accion'])); //la accion que se toma
$funcionNombre = $metodo . ucfirst($accion[0]); // funcion contruida con el metodo + la accion
$parametros = array_slice($accion, 1); // parametros de la funcion

// Si hay parametros y es GET 
if (count($parametros) > 0 && $metodo == 'get') {
    $funcionNombre = $funcionNombre.'ConParametros';
}

//Si existe la funcion...llamarla! si no entra al else
if (function_exists($funcionNombre)) {
    call_user_func_array ($funcionNombre, $parametros);
} else {
    outputError(400);
}

// Funcion centralizada de manejo de errores
function outputError($codigo = 500)
{
    switch ($codigo) {
        case 401:
            header($_SERVER["SERVER_PROTOCOL"] . " 401 Unauthorized", true, 401); // Acceso denegado por contrasenia incorrecta
            die;
        case 400:
            header($_SERVER["SERVER_PROTOCOL"] . " 400 Bad request", true, 400); // Error en el protocolo HTTP
            die;
        case 404:
            header($_SERVER["SERVER_PROTOCOL"] . " 404 Not Found", true, 404); // Recurso no encontrado
            die;
        default:
            header($_SERVER["SERVER_PROTOCOL"] . " 500 Internal Server Error", true, 500); // Error en el servidor
            die;
            break;
    }
}

// Funcion para los estatus 200 OK y los 201 Created
function outputJson($data, $codigo = 200)
{
    header('', true, $codigo);
    header('Content-type: application/json');
    print json_encode($data);
    die;
}

/*************************** API *********************************/

/**
 * POST /restore
 * Restaura la base de datos al estado original definido en el script SQL.
 */
function postRestore() 
{
    global $link;
    
    //Solo el Owner (rol 2) debería poder resetear la DB
    $usuario = validarToken();
    if ((int)$usuario['role'] != 2) {
        outputError(401);
    }

    //Ruta al archivo SQL
    $sqlFile = "../database/musiclab_db.sql";
    
    if (!file_exists($sqlFile)) {
        outputJson(["error" => "Archivo SQL no encontrado"], 500);
    }

    //Leer y limpiar el contenido del archivo
    $sqlContent = file_get_contents($sqlFile);
    
    // mysqli_multi_query permite ejecutar múltiples sentencias SQL a la vez
    if (mysqli_multi_query($link, $sqlContent)) {
        // Debemos "vaciar" los resultados de multi_query para que la conexión quede libre
        do {
            if ($result = mysqli_store_result($link)) {
                mysqli_free_result($result);
            }
        } while (mysqli_next_result($link));

        outputJson([
            "status" => "success", 
            "message" => "Base de datos restaurada correctamente al estado inicial."
        ]);
    } else {
        outputJson(["error" => mysqli_error($link)], 500);
    }
}

// Obtener todos los usuarios
/*
 GET      users     
 [
    {
        "id": 1,  // int  
        "first_name": "Bautista",  // string
        "last_name": "Rodriguez", // string
        "email": "Owner@gmail.com", // string
        "Password": "123456", // int,
        "role": "0 = Owner", // int
        "Artists_type": ,
        Bio: '' , // string
        profike_img_url: '' , // string
        status: '' , // string
        created_at: '' // timestamp
    },
    {...}
]
*/

function getUsers() 
{
    global $link;
    $sql = "SELECT * FROM users";
    $result = mysqli_query($link, $sql);
    
    if ($result===false) {
        outputError(500);
    }

    $ret = [];
    while ($fila = mysqli_fetch_assoc($result)) {
        settype($fila['id'], 'integer');
        settype($fila['role'], 'integer');
        $ret[] = $fila;
    }

    mysqli_free_result($result);
    mysqli_close($link);
    outputJson($ret);
}

// Obtener un usuario específico por su ID
/*
 GET      users/{id}     
 {
    "id": 1,
    "first_name": "Bautista",
    "last_name": "Rodriguez",
    "email": "owner@gmail.com",
    "role": 2,
    "artist_type": "Developer",
    "bio": "Creador de MusicLab.",
    "profile_img_url": "default_profile.png",
    "status": "active",
    "created_at": "2026-01-21 13:57:06"
 }
*/
function getUsersConParametros($id) 
{
    global $link;

    // Sanitización del parámetro para evitar inyecciones SQL
    $id = mysqli_real_escape_string($link, $id);

    // Consulta para obtener solo el usuario solicitado
    $sql = "SELECT id, first_name, last_name, password, email, role, artist_type, bio, profile_img_url, status, created_at 
            FROM users 
            WHERE id = $id";

    $result = mysqli_query($link, $sql);
    
    if ($result === false) {
        outputError(500); // Error interno del servidor
    }

    $usuario = mysqli_fetch_assoc($result);

    if ($usuario) {
        // Ajuste de tipos para que coincidan con tu estándar de la API
        settype($usuario['id'], 'integer');
        settype($usuario['role'], 'integer');
        
        outputJson($usuario); // Retorna el objeto del usuario encontrado
    } else {
        outputError(404); // Recurso no encontrado si el ID no existe
    }
}


// Obtener todas las publicaciones (muro de música)
/*
 GET      posts     
 [
    {
        "id": 1,
        "title": "Nueva Demo Rock",
        "description": "Un adelanto de mi próximo EP.",
        "file_url": "audio_demo_1.mp3",
        "file_type": "audio",
        "artist_name": "Julian Casablancas"
    },
    {...}
 ]
*/
function getPosts()
{
    global $link;
    
    //traer el nombre del artista junto con el post
    $sql = "SELECT p.id, 
                   p.title, 
                   p.description, 
                   p.file_url, 
                   p.file_type, 
                   CONCAT(u.first_name, ' ', u.last_name) as artist_name 
            FROM 
                posts p
            INNER JOIN 
                users u ON p.user_id = u.id
            ORDER BY 
                p.created_at 
            DESC";

    $result = mysqli_query($link, $sql);
    
    if ($result === false) {
        outputError(500);
    }

    $ret = [];
    while ($fila = mysqli_fetch_assoc($result)) {
        settype($fila['id'], 'integer');
        $ret[] = $fila;
    }

    mysqli_free_result($result);
    outputJson($ret);
}

// postUsers --> crear nuevos usario que no estan registrados en la BD
function postUsers() 
{
    global $link;
    $data = json_decode(file_get_contents('php://input'), true);

    // Campos estrictamente necesarios según tu formulario y tabla
    if (empty($data['first_name']) || empty($data['last_name']) || 
        empty($data['email']) || empty($data['password']) || empty($data['artist_type'])) {
        outputError(400); // Bad Request si falta algún dato obligatorio
    }

    // Sanitización
    $first_name = mysqli_real_escape_string($link, $data['first_name']);
    $last_name = mysqli_real_escape_string($link, $data['last_name']);
    $email = mysqli_real_escape_string($link, $data['email']);
    $artist_type = mysqli_real_escape_string($link, $data['artist_type']);
    $bio = !empty($data['bio']) ? mysqli_real_escape_string($link, $data['bio']) : '';
    
    // El password a texto plano
    $passwordHash = password_hash($data['password'], PASSWORD_DEFAULT);

    // Inserción (el rol es 0 y la imagen es default por estructura de tabla)
    $sql = "INSERT INTO users (first_name, last_name, email, password, artist_type, bio, profile_img_url, role) 
            VALUES ('$first_name', '$last_name', '$email', '$passwordHash', '$artist_type', '$bio', 'default_profile.png', 0)";

    if (mysqli_query($link, $sql)) {
        $userId = mysqli_insert_id($link);
        
        $token = generarJWT($userId, $email, 0); 

        outputJson([
            "status" => "success",
            "token" => $token,
            "user" => [
                "id" => $userId,
                "first_name" => $first_name,
                "role" => 0
            ]
        ], 201);
    } else {
        outputError(500);
    }
}

function generarJWT($id, $email, $role) {
    $key = "Tu_Clave_Secreta_MusicLab_2026"; // Tu llave maestra

    // 1. Header (Tipo de token y algoritmo)
    $header = json_encode(['typ' => 'JWT', 'alg' => 'HS256']);
    $headerBase64 = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($header));

    // 2. Payload (Datos del usuario)
    $payload = json_encode([
        'iat' => time(),
        'exp' => time() + 3600,
        'data' => ['id' => $id, 'email' => $email, 'role' => $role]
    ]);
    $payloadBase64 = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($payload));

    // 3. Signature (Firma de seguridad)
    $signature = hash_hmac('sha256', "$headerBase64.$payloadBase64", $key, true);
    $signatureBase64 = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($signature));

    return "$headerBase64.$payloadBase64.$signatureBase64";
}

function validarToken() 
{
    $headers = apache_request_headers(); 
    
    // Normalizamos la búsqueda del header (algunos servidores usan minúsculas)
    $authHeader = $headers['Authorization'] ?? $headers['authorization'] ?? null;

    if (!$authHeader) {
        outputError(401); 
    }

    $token = str_replace('Bearer ', '', $authHeader);
    $partes = explode('.', $token);

    if (count($partes) !== 3) {
        outputError(401); 
    }

    // REPARACIÓN: Revertimos el formato Base64URL antes de decodificar
    $payloadBase64 = str_replace(['-', '_'], ['+', '/'], $partes[1]);
    $payload = json_decode(base64_decode($payloadBase64), true);

    // Verificamos que los datos existan y el token no haya expirado
    if (!$payload || !isset($payload['exp']) || $payload['exp'] < time()) {
        outputError(401); 
    }

    return $payload['data']; 
}

// POST login --> inicio de sesion una vez registrado
function postLogin() 
{
    global $link;
    $json_raw = file_get_contents('php://input');
    $data = json_decode($json_raw, true);

    if (!isset($data['email']) || !isset($data['password'])) {
        outputError(401); 
    }

    // sanitizas el email
    $email = mysqli_real_escape_string($link, $data['email']);

    // 2. Buscar al usuario en la base de datos
    $sql = "SELECT id, first_name, email, password, role FROM users 
            WHERE email = '$email'";

    $resultado = mysqli_query($link, $sql);
    $usuario = mysqli_fetch_assoc($resultado);

    // 3. Validar con password_verify
    if ($usuario && password_verify($data['password'], $usuario['password'])) {
        
        // 4. Generar el JWT 
        $token = generarJWT($usuario['id'], $usuario['email'], $usuario['role']);

        // 5. Enviar respuesta exitosa (sin la contraseña por seguridad)
        unset($usuario['password']);
        outputJson([
            "status" => "success",
            "token" => $token,
            "user" => $usuario
        ], 200);

    } else {
        // Si el usuario no existe o la clave es mal, error 401
        outputError(401);
    }
}

function patchUsers($id)
{
    global $link;
    
    //Validamos el token y obtenemos quién hace la petición
    $editor = validarToken();
    $id_editor = (int) $editor['id'];
    $rol_editor = (int) $editor['role'];
    $id_usuario_modificar = (int) $id;

    //obtener los datos del usuario a editar...
    $sql = "SELECT 
                *
            FROM 
                users 
            WHERE 
                id = $id_usuario_modificar";

    $res = mysqli_query($link, $sql);
    $original = mysqli_fetch_assoc($res);

    if (!$original) {
        outputError(404); // El usuario a editar no existe
    }

    $rol_destino = (int)$original['role'];// averiguamos el nivel de permisos/cuenta que posee el usuario a editar

    $puedeEditar = false;

    // Uno mismo siempre puede editarse
    if ($id_editor == $id_usuario_modificar) {
        $puedeEditar = true;
    } 

    //El Owner (rol 2) puede editar a cualquiera
    elseif ($rol_editor == 2) {
        $puedeEditar = true;
    }

    // Los Admin (rol 1) pueden editar artistas (rol 0)
    // Pero NO pueden tocar al Owner (2) ni a otros Admins (1)
    elseif ($rol_editor == 1 && $rol_destino == 0) {
        $puedeEditar = true;
    }

    if (!$puedeEditar) {
        outputError(401); // No tiene permisos para esta acción
    }

    $data = json_decode(file_get_contents('php://input'), true);
    
    // Sanitización
    // Si el campo viene vacío o es igual al anterior, usamos el valor de $original
    $first_name = !empty($data['first_name']) ? mysqli_real_escape_string($link, $data['first_name']) : $original['first_name'];
    $last_name = !empty($data['last_name']) ? mysqli_real_escape_string($link, $data['last_name']) : $original['last_name'];
    $email = !empty($data['email']) ? mysqli_real_escape_string($link, $data['email']) : $original['email'];
    $artist_type= !empty($data['artist_type'])? mysqli_real_escape_string($link, $data['artist_type']) : $original['artist_type'];
    $bio = isset($data['bio']) ? mysqli_real_escape_string($link, $data['bio']) : $original['bio'];
    $profile_img_url = !empty($data['profile_img_url']) ? mysqli_real_escape_string($link, $data['profile_img_url']) : $original['profile_img_url'];

    // Solo se cambia si se envía una nueva, sino queda el hash anterior
    $password = !empty($data['password']) ? password_hash($data['password'], PASSWORD_DEFAULT) : $original['password'];

    // Solo el Owner (rol 2) puede cambiar roles ajenos
    $role = ($rol_editor == 2 && isset($data['role'])) ? (int)$data['role'] : (int)$original['role'];

    $sql_update = "UPDATE users SET 
                    first_name = '$first_name', 
                    last_name = '$last_name', 
                    email = '$email', 
                    password = '$password', 
                    role = $role, 
                    artist_type = '$artist_type', 
                    bio = '$bio', 
                    profile_img_url = '$profile_img_url' 
                  WHERE 
                    id = $id_usuario_modificar";

    if (mysqli_query($link, $sql_update)) {
        outputJson(["status" => "success", "message" => "Perfil actualizado correctamente"]);
    } else {
        outputError(500);
    }
}

function deleteUsers($id) 
{
    global $link;
    $id_eliminar = (int) $id;

    //Validamos el token y obtenemos quién hace la petición
    $editor = validarToken();
    $id_editor = (int) $editor['id'];
    $rol_editor = (int) $editor['role'];

    $sql_busqueda = "SELECT
                        role
                    FROM
                        users
                    WHERE
                        id = $id_eliminar";

    $res_busqueda = mysqli_query($link, $sql_busqueda);
    $usuario_a_borrar = mysqli_fetch_assoc($res_busqueda);

    // si el usuario no existe... es un not found
    if(!$usuario_a_borrar)
    {
        outputError(404);
    }

    $rol_a_borrar = (int)$usuario_a_borrar['role'];

    // Solo el Owner (2) o Admin (1) pueden borrar, y SOLO pueden borrar Artistas (0)
    $es_autorizado = ($rol_editor >= 1 && $rol_a_borrar === 0);
    
    // El Owner (2) también puede borrarse a sí mismo o a Admins si lo deseas, 
    // pero según tu esquema:
    if (!$es_autorizado) {
        outputError(401); // No autorizado
    }

    // Ejecución del DELETE
    $sql_delete = "DELETE FROM 
                        users 
                    WHERE 
                        id = $id_eliminar";
    
    if (mysqli_query($link, $sql_delete)) {
        outputJson(["status" => "success", "message" => "Se eliminó el usuario correctamente"]);
    } else {
        outputError(500);
    }
}

// Cualquiera puedo eliminar sus propios registros pero los admin y el Owner pueden borrar las publicaciones de los usuarios
// Los admin no pueden tocar al Owner
function deletePosts($id)
{
    global $link;
    $publicacion_a_eliminar = (int)$id;

    // el que esta logueado
    $editor = validarToken();
    $id_editor = (int)$editor['id'];
    $editor_role = (int)$editor['role'];

    // Comprobar si existe es publicacion...
    $sql_busqueda = "SELECT
                        *
                    FROM
                        posts
                    WHERE
                        id = $publicacion_a_eliminar";
    
    $res = mysqli_query($link, $sql_busqueda);
    $existe = mysqli_fetch_assoc($res);

    // datos del autor de la publicacion
    $usuario_publicacion = (int)['user_id'];
    $usuario_publicacion_role = (int)['role'];

    if(!$existe)
    {
        outputError(404); // not found
    }

    $sql_delete = "DELETE FROM
                posts
            WHERE
                id = $publicacion_a_eliminar";

    $puede_borrar = false;

    // Comprobaciones...
    // si el editor es el mismo...puede hacerlo
    if($id_editor === $usuario_publicacion)
    {
        $puede_borrar = true;
    }
    // si es el Owner...puede borrar la que quiera
    else if($rol_editor === 2)
    {
        $puede_borrar = true;
    }
    // los admin pueden eliminar las publicaciones de los usuarios
    else if ($rol_editor === 1 && $usuario_publicacion_role === 0) {
        $puede_borrar = true;
    }
    // ejecutar la peticion sql...
    if($puede_borrar)
    {
        if (mysqli_query($link, $sql_delete)) {
            outputJson(["status" => "success", "message" => "Se eliminó la publicacion correctamente"]);
        } else {
            outputError(500);
        }
    }
    else
    {
        outputError(401); // no tiene permisos para borrar esta publicacion...
    }
}

?>