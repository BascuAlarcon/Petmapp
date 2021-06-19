<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class TipoAlerta extends Model
{
    use HasFactory;
    protected $table="tipos_alertas";
    use SoftDeletes;

    public function alertas(){
        return $this->hasMany('App\Models\Alerta', 'tipo_alerta_id', 'id');
    }
}
