<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
class PeticionCuidado extends Model
{
    use HasFactory;
    protected $table = "peticion_cuidado";
    protected $primaryKey = "id";
    use SoftDeletes;  

    public function usuario(){
        return $this->belongsTo('App\Models\User');
    }

    public function publicacion(){
        return $this->belongsTo('App\Models\Publicacion');
    }

    public function servicios(){
        return $this->hasMany('App\Models\Servicio', 'peticion_cuidado_id', 'id');
    }

    public function evaluaciones(){
        return $this->hasMany('App\Models\Evaluacion', 'peticion_cuidado_id', 'id');
    }
}
