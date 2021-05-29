<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Ubicacion extends Model
{
    use HasFactory;
    protected $table = "ubicaciones";
    use SoftDeletes;

    public function comentarios(){
        return $this->hasMany('App\Models\ComentarioUbicacion', 'id_ubicacion', 'id');
    }
}
