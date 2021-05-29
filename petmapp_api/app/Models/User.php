<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Tymon\JWTAuth\Contracts\JWTSubject;
use Illuminate\Database\Eloquent\SoftDeletes;
class User extends Authenticatable implements JWTSubject
{
    use HasFactory, Notifiable;
    protected $primaryKey = "rut";
    protected $table= "usuarios"; 
    use SoftDeletes;  

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    /**
     * Return a key value array, containing any custom claims to be added to the JWT.
     *
     * @return array
     */
    public function getJWTCustomClaims()
    {
        return [];
    }

    public function perfil(){
        return $this->belongsTo('App\Models\Perfil');
    }

    public function mascotas(){
        return $this->hasMany('App\Models\Mascota', 'usuario_rut', 'rut');
    }

    public function hogares(){
        return $this->hasMany('App\Models\Hogar', 'usuario_rut', 'rut');
    }

    public function alertas (){
        return $this->hasMany('App\Models\Alerta', 'usuario_rut', 'rut');
    }

    public function comentarioAlerta (){
        return $this->hasMany('App\Models\ComentarioAlerta', 'usuario_rut', 'rut');
    }

    public function comentarioNegocio (){
        return $this->hasMany('App\Models\ComentarioNegocio', 'usuario_rut', 'rut');
    }

    public function comentarioUbicacion (){
        return $this->hasMany('App\Models\ComentarioUbicacion', 'usuario_rut', 'rut');
    }
}
