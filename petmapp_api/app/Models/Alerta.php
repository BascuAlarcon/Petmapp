<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model; 

class Alerta extends Model
{
    use HasFactory;
    protected $table = "alertas"; 

    public function usuario(){
        return $this->belongsTo('App\Models\User');
    }

    public function comentarios(){
        return $this->hasMany('App\Models\ComentarioAlerta');
    }

    public function tipo(){
        return $this->belongsTo('App\Models\TipoAlerta');
    }
}
