<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
class Perfil extends Model
{
    use HasFactory;
    protected $table='perfiles'; 
    use SoftDeletes;  
    public function users(){
        return $this->HasMany('App\Models\User');
    }
}
