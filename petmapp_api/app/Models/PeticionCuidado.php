<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
class PeticionCuidado extends Model
{
    use HasFactory;
    protected $table = "peticion_cuidado";
    use SoftDeletes;  
}
