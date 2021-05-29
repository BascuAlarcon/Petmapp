<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class ComentarioAlerta extends Model
{
    use HasFactory;
    protected $table = "comentarios_alertas";
    use SoftDeletes;

    public function alerta(){
        return $this->belongsTo('App\Models\Alerta');
    }

    public function usuario(){
        return $this->belongsTo('App\Models\User');
    }
}
