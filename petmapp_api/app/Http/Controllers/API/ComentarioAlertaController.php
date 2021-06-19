<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\ComentarioAlerta;
use Illuminate\Http\Request;

class ComentarioAlertaController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return ComentarioAlerta::all();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $comentarioAlerta = new ComentarioAlerta();
        $comentarioAlerta->descripcion= $request->descripcion;
        $comentarioAlerta->fecha_emision = $request->fecha_emision ;
        $comentarioAlerta->foto = $request->foto ;
        $comentarioAlerta->alerta_id = $request->alerta_id ;
        $comentarioAlerta->usuario_rut = $request->usuario_rut ;
        $comentarioAlerta->save();
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\ComentarioAlerta  $comentarioAlerta
     * @return \Illuminate\Http\Response
     */
    public function show(ComentarioAlerta $comentarioAlerta)
    {
        return $comentarioAlerta;
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\ComentarioAlerta  $comentarioAlerta
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, ComentarioAlerta $comentarioAlerta)
    {
        $comentarioAlerta->descripcion= $request->descripcion;
        $comentarioAlerta->fecha_emision = $request->fecha_emision ;
        $comentarioAlerta->foto = $request->foto ; 
        $comentarioAlerta->save();
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\ComentarioAlerta  $comentarioAlerta
     * @return \Illuminate\Http\Response
     */
    public function destroy(ComentarioAlerta $comentarioAlerta)
    {
        $comentarioAlerta->delete();
    }

    
}
