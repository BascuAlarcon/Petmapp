<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class ComentarioUbicacion extends Model
{
    use HasFactory;
    protected $table = "comentarios_ubicaciones";
    use SoftDeletes;

    public function ubicacion(){
        return $this->belongsTo('App\Models\Ubicacion');
    }

    public function usuario(){
        return $this->belongsTo('App\Models\User');
    }
}
