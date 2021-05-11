<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\RazaController;
use App\Http\Controllers\API\MascotaController;
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
Route::apiResource('/razas', 'App\Http\Controllers\API\RazaController')->parameters(['razas'=>'raza']);
Route::apiResource('/mascotas', 'App\Http\Controllers\API\MascotaController')->parameters(['mascotas'=>'mascota']);
Route::apiResource('/cuidados', 'App\Http\Controllers\API\CuidadoController')->parameters(['cuidados'=>'cuidado']);
Route::apiResource('/especies', 'App\Http\Controllers\API\EspecieController')->parameters(['especies'=>'especie']); 
Route::apiResource('/evaluaciones', 'App\Http\Controllers\API\EvaluacionController')->parameters(['evaluaciones'=>'evaluacion']);
Route::apiResource('/hogares', 'App\Http\Controllers\API\HogarController')->parameters(['hogares'=>'hogar']);
Route::apiResource('/perfiles', 'App\Http\Controllers\API\PerfilController')->parameters(['perfiles'=>'perfil']);
Route::apiResource('/peticiones', 'App\Http\Controllers\API\PeticionCuidadoController')->parameters(['peticiones'=>'peticion']);
Route::apiResource('/publicaciones', 'App\Http\Controllers\API\PublicacionController')->parameters(['publicaciones'=>'publicacion']);
Route::apiResource('/servicios', 'App\Http\Controllers\API\ServicioController')->parameters(['servicios'=>'servicio']); 

// Listar por id // 
Route::get('razas/{raza}/mascotas', 'App\Http\Controllers\API\RazaController@mascotas');  

// USUARIO // 
Route::group([
    'middleware' => 'api',
    'prefix' => 'auth', 
], function () {

    Route::post('login', [AuthController::class, 'login']);
    Route::post('logout', [AuthController::class, 'logout']);
    Route::post('register', [AuthController::class, 'register']);  
    Route::get('index', [AuthController::class, 'index']); 
    Route::get('{usuario}/mascotas', [AuthController::class, 'mascotas']);  
    Route::post('me', [AuthController::class, 'me']); 
});