<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
class Cuidado extends Model
{
    protected $table = "cuidados";
    use SoftDeletes;    
    use HasFactory;
}
