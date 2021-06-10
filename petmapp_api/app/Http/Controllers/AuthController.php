<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Usuario;

class AuthController extends Controller
{
    /**
     * Create a new AuthController instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('jwt', ['except' => ['index', 'me', 'login','editar' ,'register', 'logout' ,'perfil', 'mascotas', 'hogares','publicaciones', 'peticiones']]);
    }

    /**
     * Get a JWT via given credentials.
     *
     * @return \Illuminate\Http\JsonResponse
     */

    public function index(){
        return Usuario::all();
    }
    
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

    public function editar(Request $request, Usuario $user)
    {  
        $user->email = $request->email; 
        $user->name = $request->name;
        $user->sexo = $request->sexo;
        $user->perfil_id = $request->perfil_id;
        $user->fecha_nacimiento = $request->fecha_nacimiento;
        $user->foto = $request->foto;
        $user->numero_telefonico = $request->numero_telefonico;
        $user->promedio_evaluaciones = $request->promedio_evaluaciones;
        $user->calendario = $request->calendario;
        $user->save();
    }

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
