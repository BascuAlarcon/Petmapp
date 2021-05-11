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
        $this->middleware('jwt', ['except' => ['index','login', 'me', 'register', 'logout' , 'mascotas']]);
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
        // return response()->json(auth()->user());
        $user = auth()->user(); 
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
  
    public function mascotas(User $user){
        $user->load('mascotas');
        return $user;
    }
}
