<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\RazaController;
use App\Http\Controllers\API\MascotaController;
use App\Http\Controllers\API\UserController;
use App\Http\Controllers\AuthController;


/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

/* Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
}); */

// todas las rutas de el archivo de routes api.php, llevan un prefijo API en el navegador // 
  
// rutas //
Route::apiResource('/razas',        'App\Http\Controllers\API\RazaController')->parameters(['razas'=>'raza']);
Route::apiResource('/mascotas',     'App\Http\Controllers\API\MascotaController')->parameters(['mascotas'=>'mascota']);
Route::apiResource('/especies',     'App\Http\Controllers\API\EspecieController')->parameters(['especies'=>'especie']);  
Route::apiResource('/hogares',      'App\Http\Controllers\API\HogarController')->parameters(['hogares'=>'hogar']);
Route::apiResource('/perfiles',     'App\Http\Controllers\API\PerfilController')->parameters(['perfiles'=>'perfil']); 
Route::apiResource('/publicaciones', 'App\Http\Controllers\API\PublicacionController')->parameters(['publicaciones'=>'publicacion']);
Route::apiResource('/servicios',    'App\Http\Controllers\API\ServicioController')->parameters(['servicios'=>'servicio']); 
Route::apiResource('/alertas',      'App\Http\Controllers\API\AlertaController')->parameters(['alertas'=>'alerta']); 
Route::apiResource('/negocios',     'App\Http\Controllers\API\NegocioController')->parameters(['negocios'=>'negocio']); 
Route::apiResource('/ubicaciones', 'App\Http\Controllers\API\UbicacionController')->parameters(['ubicaciones'=>'ubicacion']); 
Route::apiResource('/tipos', 'App\Http\Controllers\API\TipoController')->parameters(['tipos'=>'tipo']); 
Route::apiResource('/comentariosAlerta', 'App\Http\Controllers\API\ComentarioAlertaController')->parameters(['comentariosAlerta'=>'comentarioAlerta']); 
Route::apiResource('/comentariosNegocio', 'App\Http\Controllers\API\ComentarioNegocioController')->parameters(['comentariosNegocio'=>'comentarioNegocio']); 
Route::apiResource('/comentariosUbicacion', 'App\Http\Controllers\API\ComentarioUbicacionController')->parameters(['comentariosUbicacion'=>'comentarioUbicacion']); 
Route::apiResource('/peticiones',   'App\Http\Controllers\API\PeticionController')->parameters(['peticiones'=>'peticion']);
Route::apiResource('/tiposAlerta',      'App\Http\Controllers\API\TipoAlertaController')->parameters(['tiposAlerta'=>'tipoAlerta']);
Route::apiResource('/tiposUbicacion', 'App\Http\Controllers\API\TipoUbicacionController')->parameters(['tiposUbicacion'=>'tipoUbicacion']);


// Listar por id // 
Route::get('razas/{raza}/mascotas', 'App\Http\Controllers\API\RazaController@mascotas');   
Route::get('especies/{especie}/razas', 'App\Http\Controllers\API\EspecieController@razas');
Route::get('publicaciones/{publicacion}/peticiones', 'App\Http\Controllers\API\PublicacionController@peticiones');
Route::get('publicaciones/{publicacion}/peticioness', 'App\Http\Controllers\API\PublicacionController@peticiones2');
Route::get('peticiones/{peticion}/mascotas', 'App\Http\Controllers\API\PeticionController@mascotas');
/* Route::get('peticiones/{peticion}/evaluaciones', 'App\Http\Controllers\API\PeticionController@evaluaciones'); */
Route::get('peticiones/{peticion}/servicios', 'App\Http\Controllers\API\PeticionController@servicios'); 
Route::get('negocios/{negocio}/comentarios', 'App\Http\Controllers\API\NegocioController@comentarios');
Route::get('ubicaciones/{ubicacion}/comentarios', 'App\Http\Controllers\API\UbicacionController@comentarios');

// Editar tabla peticion //
Route::post('publicaciones/{publicacion}/comentario', 'App\Http\Controllers\API\PublicacionController@comentario');   
Route::post('peticiones/{peticion}/comentario', 'App\Http\Controllers\API\PeticionController@comentario');   
Route::post('peticiones/{peticion}/respuesta', 'App\Http\Controllers\API\PeticionController@respuesta'); 
Route::post('peticiones/{peticion}/monto', 'App\Http\Controllers\API\PeticionController@monto'); 
Route::post('peticiones/{peticion}/termino', 'App\Http\Controllers\API\PeticionController@termino'); 
 
// Editar campo última actividad de tabla Alerta //
Route::post('alertas/{alerta}/ultima', 'App\Http\Controllers\API\AlertaController@ultima'); 
Route::get('alertas/{alerta}/comentarios', 'App\Http\Controllers\API\AlertaController@comentarios');
// USUARIO //   
Route::group([
    'middleware' => 'api',
    'prefix' => 'auth',
], function(){
    Route::post('login',                [AuthController::class, 'login']);
    Route::post('logout',               [AuthController::class, 'logout']); 
    Route::post('register',             [AuthController::class, 'register']);  
    Route::post('me',                   [AuthController::class, 'me']);
    Route::get('me/publicaciones',      [AuthController::class, 'publicaciones']);
    Route::get('me/peticiones',         [AuthController::class, 'peticiones']);
    Route::get('me/mascotas',           [AuthController::class, 'mascotas']);
    Route::get('me/perfil',             [AuthController::class, 'perfil']);
    Route::get('me/hogares',            [AuthController::class, 'hogares']);
    Route::get('me/alertas',            [AuthController::class, 'alertas']);
    // USER CONTROLLER //
    Route::get('usuarios',                      [UserController::class, 'index']);
    Route::get('usuarios/{usuario}',            [UserController::class, 'show']);
    Route::put('usuarios/{usuario}',            [UserController::class, 'editarPerfil']);
    Route::delete('usuarios/{usuario}',         [UserController::class, 'destroy']);
    Route::put('usuarios/{usuario}/evaluacion', [UserController::class, 'evaluacion']); 
    Route::put('usuarios/{usuario}/cambiar',    [UserController::class, 'cambiar']); 
    Route::put('usuarios/{usuario}/deshabilitar',    [UserController::class, 'deshabilitar']); 
     
});