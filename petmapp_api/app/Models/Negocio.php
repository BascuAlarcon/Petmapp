<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Negocio extends Model
{
    use HasFactory;
    protected $table = "negocios";
    use SoftDeletes;

    public function tipo(){
        return $this->belongsTo('App\Models\Tipo');
    }

    public function comentarios(){
        return $this->hasMany('App\Models\ComentarioNegocio');
    }
}
