<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class ComentarioNegocio extends Model
{
    use HasFactory;
    protected $table = "comentarios_negocios";
    use SoftDeletes;

    public function negocio(){
        return $this->belongsTo('App\Models\Negocio');
    }

    public function usuario(){
        return $this->belongsTo('App\Models\User');
    }
}
