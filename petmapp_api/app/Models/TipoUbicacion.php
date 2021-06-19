<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class TipoUbicacion extends Model
{
    use HasFactory;
    protected $table="tipos_ubicaciones";
    use SoftDeletes;

    public function ubicaciones(){
        return $this->hasMany('App\Models\Ubicacion','tipo_ubicacion_id','id');
    }
}
