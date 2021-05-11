<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
class Especie extends Model
{
    protected $table = "especies";
    use SoftDeletes;  
    use HasFactory;

    public function razas(){
        return $this->hasMany('App/Models/Raza');
    }
}
