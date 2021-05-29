<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Tipo extends Model
{
    use HasFactory;
    protected $table = "tipos";
    use SoftDeletes;

    public function negocios(){
        return $this->hasMany('App\Models\Negocio');
    }
}
