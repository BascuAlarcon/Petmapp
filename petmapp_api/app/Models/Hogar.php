<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
class Hogar extends Model
{
    protected $table = "hogares";
    use SoftDeletes;  
    use HasFactory;

    public function usuario(){
        return $this->belongsTo('App\Models\User');
    }

    public function publicaciones(){
        return $this->hasMany('App\Models\Publicacion');
    }
}
