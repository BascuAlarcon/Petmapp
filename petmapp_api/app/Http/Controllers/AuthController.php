<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;

class AuthController extends Controller
{
    /**
     * Create a new AuthController instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('jwt', ['except' => ['index', 'me', 'login', 'register', 'logout' ,'perfil', 'mascotas', 'hogares','publicaciones', 'peticiones']]);
    }

    /**
     * Get a JWT via given credentials.
     *
     * @return \Illuminate\Http\JsonResponse
     */

    public function index(){
        return User::all();
    }
    
    public function me(User $user)
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
        $user = new User();
        $user->rut = $request->rut;
        $user->name = $request->name;
        $user->email = $request->email;
        $user->password = bcrypt($request->password);
        $user->perfil_id = 1;
        $user->save();
        return response()->json(['status'=>'ok' ,'data'=>$user], 200);
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

    public function perfil(User $user){
        $user = Auth::user();
        $perfil = $user->perfil;
        return $perfil;
    }
  
    public function mascotas(User $user){
        $user = Auth::user();
        $mascotas = $user->mascotas;
        return $mascotas;
    }

    public function hogares(User $user){
        $user = Auth::user();
        $hogares = $user->hogares;
        return $hogares;
    }

    public function publicaciones(User $user){ 
        $user = Auth::user();
        $publicaciones = $user->publicaciones;
        return $publicaciones;
    }

    public function peticiones(User $user){
        $user = Auth::user();
        $peticiones = $user->peticiones;
        return $peticiones;
    }
}
