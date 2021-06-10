<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Notifications\Notifiable;
use Tymon\JWTAuth\Contracts\JWTSubject;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Usuario extends Model implements JWTSubject
{ 
    use HasFactory, Notifiable; 
    protected $table= "usuarios"; 
    protected $primaryKey = "rut";
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

    public function publicaciones (){
        return $this->hasMany('App\Models\Publicacion', 'usuario_rut', 'rut');
    }

    public function peticiones (){
        return $this->hasMany('App\Models\Peticion', 'usuario_rut', 'rut');
    }
}