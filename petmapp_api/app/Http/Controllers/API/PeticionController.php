<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Peticion;
use App\Models\Mascota;
use App\Models\Servicio;
use Illuminate\Http\Request;

class PeticionController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Peticion::all();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $peticion = new Peticion();
        $peticion->fecha_inicio = $request->fecha_inicio;
        $peticion->fecha_fin = $request->fecha_fin; 
        $peticion->descripcion = $request->descripcion; 
        $peticion->estado = 1; 
        $peticion->usuario_rut = $request->usuario_rut;
        $peticion->publicacion_id = $request->publicacion_id;
        //$peticion->precio_total = $request->precio_total;
        //$peticion->nota = $request->nota;
        //$peticion->comentario = $request->comentario;
        $peticion->save();
        // TABLA M:N PETICION MASCOTA
        if($request->mascota1 != null){
            $peticion->mascotas()->attach($request->mascota1);      
        }
        if($request->mascota2 != null){ 
            $peticion->mascotas()->attach($request->mascota2);
        }
        if($request->mascota3 != null){ 
            $peticion->mascotas()->attach($request->mascota3);
        }
        if($request->mascota4 != null){ 
            $peticion->mascotas()->attach($request->mascota4);
        }
        if($request->mascota5 != null){ 
            $peticion->mascotas()->attach($request->mascota5);
        }  
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Peticion  $peticion
     * @return \Illuminate\Http\Response
     */
    public function show(Peticion $peticion)
    {
        return $peticion;
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Peticion  $peticion
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Peticion $peticion)
    {
        $peticion->fecha_inicio = $request->fecha_inicio;
        $peticion->fecha_fin = $request->fecha_fin;  
        $peticion->descripcion = $request->descripcion; 
        //$peticion->precio_total = $request->precio_total;
        $peticion->save(); 
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Peticion  $peticion
     * @return \Illuminate\Http\Response
     */
    public function destroy(Peticion $peticion)
    {
        $peticion->delete(); 
    }

    public function respuesta(Request $request, Peticion $peticion){ 
        $peticion->estado = $request->estado; 
        $peticion->save();
    }

    public function comentario(Request $request, Peticion $peticion){ 
        $peticion->comentario = $request->comentario; 
        $peticion->nota = $request->nota; 
        $peticion->save();
    }

    public function monto(Request $request, Peticion $peticion){  
        $peticion->boleta = $request->boleta;
        $peticion->save();  
    }
 
    public function servicios($peticion){ 
        $servicios = Servicio::where('peticion_id', $peticion)->get();
        return $servicios;   
    }
}
