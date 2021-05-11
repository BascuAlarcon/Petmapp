<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;       // para el borrado logico //

class Raza extends Model
{
    use HasFactory; 
    protected $table = "razas";

    use SoftDeletes;                                 // para el borrado logico //

    public function mascotas()
    {
        return $this->hasMany('App\Models\Mascota');
    }

    public function especie(){
        return $this->belongsTo('App\Models\Especie');
    }
}
