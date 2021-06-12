<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Peticion extends Model
{
    use HasFactory;
    protected $table = "peticiones";
    use SoftDeletes;

    public function publicacion(){
        return $this->belongsTo('App\Models\Publicacion');
    }

    public function usuario(){
        return $this->belongsTo('App\Models\User');
    }

    public function servicios(){
        return $this->hasMany('App\Models\Servicio', 'peticion_id', 'id');
    }
    
    public function evaluaciones(){
        return $this->hasMany('App\Models\Evaluacion', 'peticion_id', 'id');
    }

    public function mascotas(){
        return $this->belongsToMany('App\Models\Mascotas');
    }
}
