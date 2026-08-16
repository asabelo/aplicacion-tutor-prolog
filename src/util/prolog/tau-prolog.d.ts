// http://tau-prolog.org/documentation#js
// `pl.type` no se declara a propósito: un Stream propio perdería la salida si el programa
// tocara `set_output/1` o `close/1`; por eso se sustituye el `.stream` del flujo que ya existe.

declare namespace Tau {

    type Answer = unknown;

    interface Options {
        success?: (answer: Answer) => void,
        fail?: () => void,
        error?: (error: Answer) => void,
        limit?: () => void // agotada la tanda; volver a llamar a `answer` continúa donde iba
    }

    // El objeto crudo que envuelve un Stream, donde acaba la salida
    interface RawStream {
        put: (text: string) => boolean,
        flush: () => boolean
    }

    interface Thread {
        points: unknown[] // puntos de elección pendientes
    }

    interface Session {
        consult(program: string, options: Options): void,
        query(goal: string, options: Options): void,
        answer(options: Options): void,
        format_answer(answer: Answer): string,
        streams: Record<string, { stream: RawStream }>,
        thread: Thread
    }

    interface Pl {
        create(limit?: number): Session
    }
}

interface Window {
    pl?: Tau.Pl
}
