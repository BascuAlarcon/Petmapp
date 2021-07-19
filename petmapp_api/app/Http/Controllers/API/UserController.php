<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Usuario;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class UserController extends Controller
{
     /**
     * Create a new AuthController instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('jwt', ['except' => ['index', 'me', 'login','register', 'logout', 'show', 'editarPerfil', 'destroy' , 'perfil', 'mascotas', 'hogares','publicaciones', 'peticiones', 'evaluacion']]);
    }

    /**
     * Get a JWT via given credentials.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    
    public function me(Usuario $user)
    { 
        $user = Auth::user();
        return $user;
    }

    public function login()
    {
        $credentials = request(['email', 'password']);

        if (!$token =  Auth::attempt($credentials)) {
            return response()->json(['error' => 'Unauthorized', 'message' => 'Credenciales no validas'], 401);
        }

        return $this->respondWithToken($token);
    }

    public function register(Request $request)
    {
        $user = new Usuario();
        $user->rut = $request->rut;
        $user->name = $request->name;
        $user->email = $request->email; 
        $user->password = bcrypt($request->password);
        $user->perfil_id = 2;
        $user->save();
        return response()->json(['status'=>'ok' ,'data'=>$user], 200);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */

    /**
     * Log the user out (Invalidate the token).
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function logout()
    {
        Auth::logout();

        return response()->json(['message' => 'Successfully logged out']);
    }

    /**
     * Get the token array structure.
     *
     * @param  string $token
     *
     * @return \Illuminate\Http\JsonResponse
     */
    protected function respondWithToken($token)
    {
        return response()->json([
            'access_token' => $token,
            'token_type' => 'bearer',
            'expires_in' => Auth::factory()->getTTL() * 60
        ]);
    } 

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Usuario::all();
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Usuario  $usuario
     * @return \Illuminate\Http\Response
     */
    public function show(Usuario $usuario)
    {
        return $usuario;
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Usuario  $usuario
     * @return \Illuminate\Http\Response
     */
    public function editarPerfil(Request $request, Usuario $usuario)
    {
        $usuario->email = $request->email; 
        $usuario->name = $request->name;
        $usuario->sexo = $request->sexo; 
        $usuario->fecha_nacimiento = $request->fecha_nacimiento;
        $usuario->foto = $request->foto;
        $usuario->numero_telefonico = $request->numero_telefonico;      
        $usuario->save();
         
    }

    public function evaluacion( Request $request, Usuario $usuario){
        $usuario->promedio_evaluaciones = $request->promedio_evaluaciones; 
        $usuario->save();
        return response()->json(['status'=>'ok' ,'data'=>$request->promedio_evaluaciones], 200);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Usuario  $usuario
     * @return \Illuminate\Http\Response
     */
    public function destroy(Usuario $usuario)
    {
        $usuario->delete();
    }

    public function perfil(Usuario $user){
        $user = Auth::user();
        $perfil = $user->perfil;
        return $perfil;
    }
  
    public function mascotas(Usuario $user){
        $user = Auth::user();
        $mascotas = $user->mascotas;
        return $mascotas;
    }

    public function hogares(Usuario $user){
        $user = Auth::user();
        $hogares = $user->hogares;
        return $hogares;
    }

    public function publicaciones(Usuario $user){ 
        $user = Auth::user();
        $publicaciones = $user->publicaciones;
        return $publicaciones;
    }

    public function peticiones(Usuario $user){
        $user = Auth::user();
        $peticiones = $user->peticiones;
        return $peticiones;
    }

     
}
