<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
class Mascota extends Model
{
    use HasFactory; 
    protected $table = "mascotas";
    use SoftDeletes;  


    public function raza()
    {
        return $this->belongsTo('App\Models\Raza');
    }

    public function user(){
        return $this->belongsTo('App\Models\User');
    }
}
