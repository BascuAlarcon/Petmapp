<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
class Publicacion extends Model
{
    use HasFactory;
    protected $table = "publicaciones";
    use SoftDeletes;  

    public function usuario(){
        return $this->belongsTo('App\Models\User');
    }

    public function peticiones(){
        return $this->hasMany('App\Models\Peticion', 'publicacion_id', 'id');
    }

    public function hogar(){
        return $this->belongsTo('App\Models\Hogar');
    }
}
